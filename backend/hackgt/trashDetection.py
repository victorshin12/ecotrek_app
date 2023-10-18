import numpy as np
import pandas as pd
import tensorflow as tf
from PIL import Image
#import matplotlib
# from matplotlib import pyplot as plt
from tensorflow.python.util import compat
from django.contrib.staticfiles import finders

from google.protobuf import text_format
import json
import os

from tensorflow.core.protobuf import saved_model_pb2

from object_detection.utils import visualization_utils as vis_util
from object_detection.utils import dataset_util, label_map_util
from object_detection.protos import string_int_label_map_pb2


ANNOTATIONS_FILE = finders.find('image/annotations.json')

NCLASSES = 60
with open(ANNOTATIONS_FILE) as json_file:
    data = json.load(json_file)

categories = data['categories']
labelmap = string_int_label_map_pb2.StringIntLabelMap()
for idx, category in enumerate(categories):
    item = labelmap.item.add()
    # label map id 0 is reserved for the background label
    item.id = int(category['id'])+1
    item.name = category['name']

# with open('./labelmap.pbtxt', 'w') as f:
#     f.write(text_format.MessageToString(labelmap))
# print('Label map witten to labelmap.pbtxt')

# with open('./labelmap.pbtxt') as f:
#     pprint.pprint(f.readlines())

tf.gfile = tf.io.gfile
LABELS_FILE = finders.find('image/labelmap.pbtxt')
label_map = label_map_util.load_labelmap(LABELS_FILE)
categories = label_map_util.convert_label_map_to_categories(
    label_map, max_num_classes=NCLASSES, use_display_name=True)
category_index = label_map_util.create_category_index(categories)


def reconstruct(pb_path):
    if not os.path.isfile(pb_path):
        print("Error: %s not found" % pb_path)

    print("Reconstructing Tensorflow model")
    detection_graph = tf.Graph()
    with detection_graph.as_default():
        od_graph_def = tf.compat.v1.GraphDef()
        with tf.io.gfile.GFile(pb_path, 'rb') as fid:
            serialized_graph = fid.read()
            od_graph_def.ParseFromString(serialized_graph)
            tf.import_graph_def(od_graph_def, name='')
    print("Success!")
    return detection_graph


def image2np(image):
    (w, h) = image.size
    return np.array(image.getdata()).reshape((h, w, 3)).astype(np.uint8)


def image2tensor(image):
    npim = image2np(image)
    return np.expand_dims(npim, axis=0)


def detect(test_image_path):
    with detection_graph.as_default():
        gpu_options = tf.compat.v1.GPUOptions(
            per_process_gpu_memory_fraction=0.01)
        with tf.compat.v1.Session(graph=detection_graph, config=tf.compat.v1.ConfigProto(gpu_options=gpu_options)) as sess:
            image_tensor = detection_graph.get_tensor_by_name('image_tensor:0')
            detection_boxes = detection_graph.get_tensor_by_name(
                'detection_boxes:0')
            detection_scores = detection_graph.get_tensor_by_name(
                'detection_scores:0')
            detection_classes = detection_graph.get_tensor_by_name(
                'detection_classes:0')
            num_detections = detection_graph.get_tensor_by_name(
                'num_detections:0')

            image = Image.open(test_image_path)
            (boxes, scores, classes, num) = sess.run(
                [detection_boxes, detection_scores,
                    detection_classes, num_detections],
                feed_dict={image_tensor: image2tensor(image)}
            )

            #npim = image2np(image)
            # vis_util.visualize_boxes_and_labels_on_image_array(
            #     npim,
            #     np.squeeze(boxes),
            #     np.squeeze(classes).astype(np.int32),
            #     np.squeeze(scores),
            #     category_index,
            #     use_normalized_coordinates=True,
            #     line_thickness=15)
            #plt.figure(figsize=(12, 8))
            # plt.imshow(npim)
            # plot rectangle according to the coordinates of the bounding box in boxes
            boxes = boxes.squeeze()
            classes = classes.squeeze()
            scores = scores.squeeze()
            counter = 0
            for i in range(len(boxes)):
                if boxes[i][0] == 0 and boxes[i][1] == 0 and boxes[i][2] == 0 and boxes[i][3] == 0:
                    break
                if scores[i] < .20:
                    continue
                #x1 = boxes[i][1]*npim.shape[1]
                #y1 =  boxes[i][0]*npim.shape[0]
                #x2 =  boxes[i][3]*npim.shape[1]
                #y2 =  boxes[i][2]*npim.shape[0]
                # plot a hollow rectangle with x1, y1 as top left and x2, y2 as bottom right
                # plt.gca().add_patch(plt.Rectangle((x1,y1),x2-x1,y2-y1,fill=False,color='red'))
                #plt.text(x1,y1,category_index[classes[i]]['name'] + ' ' + str(scores[i]),color='red',fontsize=20)
                counter += 1
            return counter
            # plt.show()


PB_PATH = finders.find('image/ssd_mobilenet_v2_taco_2018_03_29.pb')
detection_graph = reconstruct(PB_PATH)

# if __name__ == '__main__':
#    print(detect('archive/data/batch_3/IMG_4852.JPG'))
