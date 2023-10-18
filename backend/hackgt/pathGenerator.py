import osmnx as ox
import pandas as pd
import pickle
import networkx as nx
from django.contrib.staticfiles import finders

import time

pickle_file_path = finders.find('map/newYork.pickle')
G = pickle.load(open(pickle_file_path, "rb"))
csv_file_path = finders.find('csv/trashCans.csv')
points = pd.read_csv(csv_file_path)


def getWayPoints(startY, startX, endY, endX):
    start = ox.nearest_nodes(G, startX, startY)
    destInd = getNearestPoint(points['X'], points['Y'], endX, endY)
    dX = points['X'][destInd]
    dY = points['Y'][destInd]
    end = ox.nearest_nodes(G, dX, dY)
    route = nx.shortest_path(G, start, end, weight='weightedLength')
    coords = []
    i = 8
    while i < len(route):
        coords.append(
            {'latitude': str(G.nodes[route[i]]['y']), 'longitude': str(G.nodes[route[i]]['x'])})
        i += 8

    return coords


def getNearestPoint(X, Y, BX, BY):
    minDist = 10000000
    minIndex = 0
    for i in range(len(X)):
        dist = (BX - X[i])**2 + (BY - Y[i])**2
        if dist < minDist:
            minDist = dist
            minIndex = i
    return minIndex
