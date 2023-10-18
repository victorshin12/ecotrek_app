from rest_framework import serializers

from .models import User, Route, Point, Event


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'id', 'username', 'first_name', 'last_name', 'username', 'points'
        )


class PointSerializer(serializers.ModelSerializer):
    class Meta:
        model = Point
        fields = (
            'longitude', 'latitude'
        )


class RouteSerializer(serializers.ModelSerializer):
    start = PointSerializer()
    end = PointSerializer()
    waypoints = PointSerializer(many=True)

    class Meta:
        model = Route
        fields = (
            'start', 'end', 'waypoints'
        )
        depth = 1


class EventSerializer(serializers.ModelSerializer):
    route = RouteSerializer()
    participants = UserSerializer(many=True)

    class Meta:
        model = Event
        fields = (
            'id', 'name', 'route', 'datetime', 'participants'
        )
        depth = 2
