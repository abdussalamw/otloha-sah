from django.urls import path

from apps.entities.views import EntityListView, EntityRetrieveView, EntityCreateView, EntityUpdateView, \
    EntityAssignRoleView, EntityDestroyView, UserEntitiesListView, EntityUsersView, EntityLeaveView

app_name = 'entities'

urlpatterns = [
    path('', EntityListView.as_view(), name="list"),
    path('create/', EntityCreateView.as_view(), name="create"),
    path('update/', EntityUpdateView.as_view(), name="update"),
    path('destroy/', EntityDestroyView.as_view(), name="destroy"),
    path('user-entities/', UserEntitiesListView.as_view(), name="user_entities_list"),
    path('assign-role-user-entity/', EntityAssignRoleView.as_view(), name="assign_role"),

    path('<int:entity_id>/', EntityRetrieveView.as_view(), name="retrieve"),
    path('<int:entity_id>/leave/', EntityLeaveView.as_view(), name="leave"),
    path('<int:entity_id>/users/', EntityUsersView.as_view(), name="list_users"),

]
