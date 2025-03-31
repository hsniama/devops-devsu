from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls'))
]

# urlpatterns = [
#    path('admin/', admin.site.urls),
#    path('', include('api.urls')),  # Notar que ahora es '' en vez de 'api/'
# ]

