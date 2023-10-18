from django.shortcuts import render
from django.http import HttpResponse
from django.db.models import Q

from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response

from .pathGenerator import getWayPoints
from .models import User, Route, Event
from .serializers import UserSerializer, RouteSerializer, EventSerializer
from .utils import createRoute, startEvent, joinEvent, deleteEvent, leaveEvent
from .trashDetection import detect

# Create your views here.


def index(request):
    if request.method == 'POST':
        uploaded_file = request.FILES.get('image')
        num = detect(uploaded_file)
        return HttpResponse("Hello, world. You're at the hackgt index." + num)
    return render(request, 'image.html')


# API Views
class UserAPI(APIView):
    def get(self, request, *args, **kwargs):
        try:
            queryset = User.objects.all()
            serializer = UserSerializer(queryset, many=True)

            return Response(serializer.data, status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class RouteAPI(APIView):
    # createRoute
    def get(self, request, *args, **kwargs):
        try:
            startLong = float(request.query_params['startLongitude'])
            startLat = float(request.query_params['startLatitude'])
            endLong = float(request.query_params['endLongitude'])
            endLat = float(request.query_params['endLatitude'])

            # route = createRoute(startLat, startLong, endLat, endLong)
            wp = getWayPoints(startLat, startLong, endLat, endLong)
            # serializer = RouteSerializer(data=route)

            return Response({'start': {'latitude': str(startLat), 'longitude': str(startLong)}, 'end': {'latitude': str(endLat), 'longitude': str(endLong)}, 'waypoints': wp})

            # return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception:
            return Response(Exception, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class EventAPI(APIView):
    def get(self, request, *args, **kwargs):
        try:
            queryset = Event.objects.all()
            serializer = EventSerializer(queryset, many=True)

            return Response(serializer.data, status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def post(self, request, *args, **kwargs):
        try:
            name = request.data["name"]
            datetime = request.data["datetime"]
            event = startEvent(request.data["host"],
                               request.data["route"], name, datetime)

            return self.get(self, request, *args, **kwargs)

        except Exception:
            return Response(Exception, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request, *args, **kwargs):
        try:
            deleteEvent(request.data["event_id"])

            return Response({}, status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class JoinEventAPI(APIView):
    def get(self, request, *args, **kwargs):
        try:
            event = joinEvent(
                request.query_params["user_id"], request.query_params["event_id"])
            serializer = EventSerializer(event)

            return Response(serializer.data, status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class LeaveEventAPI(APIView):
    def get(self, request, *args, **kwargs):
        try:
            event = leaveEvent(
                request.query_params["user_id"], request.query_params["event_id"])
            serializer = EventSerializer(event)

            return Response(serializer.data, status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class PointsAPI(APIView):
    def post(self, request, *args, **kwargs):
        try:
            event = leaveEvent(
                request.query_params["user_id"], request.query_params["event_id"])
            serializer = EventSerializer(event)

            return Response(serializer.data, status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Victor will send the starting and ending long and lat, and the ML model should give the waypoints back
