from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse

def home(request):
    return HttpResponse("Hello from Django on EKS!")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home),
    path('', include('django_prometheus.urls')),
]
