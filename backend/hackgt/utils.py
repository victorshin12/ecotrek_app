from .models import User, Event, Route, Point

from .pathGenerator import getWayPoints
from .trashDetection import detect
# Laksh's Code


def addPoints(user_id, points):
    user = User.objects.get(user_id)
    user.points += points

    user.save()


def createRoute(startLat, startLong, endLat, endLong):
    starting = Point.objects.get_or_create(
        longitude=startLong, latitude=startLat)[0]
    ending = Point.objects.get_or_create(longitude=endLong, latitude=endLat)[0]

    temp_wp = getWayPoints(startLat, startLong, endLat, endLong)

    route = Route.objects.get_or_create(start=starting, end=ending)[0]

    for wp in temp_wp:
        point = Point.objects.get_or_create(
            longitude=wp['longitude'], latitude=wp['latitude'])[0]
        route.waypoints.add(point)

    route.save()

    return route


def startEvent(host_id, route_id, name, datetime):
    host = User.objects.get(id=host_id)
    route = Route.objects.get(id=route_id)
    event = Event.objects.create(
        name=name, host=host, route=route, datetime=datetime)

    event.save()
    return event


def deleteEvent(event_id):
    event = Event.objects.get(id=event_id)
    event.delete()


def joinEvent(user_id, event_id):
    event = Event.objects.get(id=event_id)
    user = User.objects.get(id=user_id)
    event.participants.add(user)
    event.save()

    return event


def leaveEvent(user_id, event_id):
    event = Event.objects.get(id=event_id)
    user = User.objects.get(id=user_id)
    event.participants.remove(user)
    event.save()

    return event


# Rohit and Rithwik's Code
def getWaypoints(start, end):
    pass
