from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),

    path('user', views.UserAPI.as_view()),
    path('route', views.RouteAPI.as_view()),
    path('events', views.EventAPI.as_view()),
    path('join-event', views.JoinEventAPI.as_view()),
    path('leave-event', views.LeaveEventAPI.as_view()),
]
