from django.contrib import admin

from .models import User, Point, Route, Event

# Register your models here.

admin.site.register(User)
admin.site.register(Point)
admin.site.register(Route)
admin.site.register(Event)
