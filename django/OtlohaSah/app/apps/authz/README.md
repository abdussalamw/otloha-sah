# Custom Permissions for Django REST Framework

This repository contains custom permission classes to be used with Django and Django REST framework. These permissions
include `DynamicPermissionRequiredMixin`, `DynamicPermissionRequired`, and `AdminPermissionRequired`.

## DynamicPermissionRequiredMixin

### Description

`DynamicPermissionRequiredMixin` is a mixin that can be used with Django views to enforce specific permissions
dynamically. This mixin allows you to define required permissions at the class level and checks them against the user's
permissions.

### Attributes

- `required_permissions`: A list of permissions required to access the view.
- `any_permissions`: A boolean that determines if any one of the permissions in `required_permissions` is sufficient (
  default is `False`).

### Methods

- `get_required_permissions(request)`: Returns the list of required permissions. By default, it returns
  the `required_permissions` attribute.
- `check_permissions(request)`: Checks if the user has the required permissions. If the user lacks any required
  permission, it denies access with a message.

### Usage Example

```python
from django.views import View

class MyView(DynamicPermissionRequiredMixin, View):
     permission_classes = [IsAuthenticated, AdminPermissionRequired]
     serializer_class = MySerializer

     def get_permission_required(self):
         return ["auth.view_group"]
     def get(self, request, *args, **kwargs):
        self.check_permissions(request)
        