from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.


class User(AbstractUser):
    points = models.PositiveBigIntegerField(default=0, null=False, blank=False)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        ordering = ('first_name', 'last_name')


class Point(models.Model):
    latitude = models.DecimalField(
        null=False, blank=False, decimal_places=14, max_digits=17)
    longitude = models.DecimalField(
        null=False, blank=False, decimal_places=14, max_digits=17)

    def __str__(self):
        return f"{self.latitude}, {self.longitude}"

    class Meta:
        ordering = ('latitude', )


class Route(models.Model):
    start = models.ForeignKey(
        Point, on_delete=models.CASCADE, blank=False, null=False, related_name="starting_point")
    end = models.ForeignKey(
        Point, on_delete=models.CASCADE, blank=False, null=False, related_name="ending_point")
    waypoints = models.ManyToManyField(
        Point, related_name="routes", blank=False)


class Event(models.Model):
    name = models.CharField(max_length=255, default="",
                            blank=False, null=False)
    host = models.ForeignKey(
        User, on_delete=models.CASCADE, blank=False, null=False)
    participants = models.ManyToManyField(
        User, related_name="events", blank=True)
    route = models.ForeignKey(
        Route, on_delete=models.CASCADE, blank=False, null=False)
    datetime = models.DateTimeField(null=False, blank=False)

    def __str__(self):
        return f"{self.name}"
