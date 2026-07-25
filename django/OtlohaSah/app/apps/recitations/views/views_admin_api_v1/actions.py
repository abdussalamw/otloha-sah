from django.shortcuts import get_object_or_404
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import DynamicPermissionRequiredMixin, AdminPermissionRequired
from apps.recitations.models.report import UserRecitationReport


# class RecitationReportAction(APIView, DynamicPermissionRequiredMixin):
#     permission_classes = [IsAuthenticated, AdminPermissionRequired]
#
#     @swagger_auto_schema(
#         operation_description="Perform an action on a user recitation report such as blocking the reportee and closing the report, or just closing the report.",
#         responses={
#             200: "Success - The action has been performed successfully.",
#             401: "Unauthorized - The user is unauthorized.",
#             403: "Forbidden - The user is not authorized to perform this action.",
#             404: "Not Found - The specified report does not exist."
#         }
#     )
#     def get_required_permissions(self, request):
#         return ('users.toggle_block_teacher',)
#
#     def post(self, request, report_id, action):
#         report = get_object_or_404(UserRecitationReport, id=report_id)
#         if action == 'block_and_close':
#             return self.block_and_close(report)
#         elif action == 'close':
#             return self.close(report)
#
#     def block_and_close(self, report):
#         report.reportee.is_blocked = True
#         report.reportee.save()
#         report.is_opened = False
#         report.save()
#         return Response({"message": "Reportee blocked and report closed"}, status=status.HTTP_200_OK)
#
#     def close(self, report):
#         report.is_opened = False
#         report.save()
#         return Response({"message": "Report closed"}, status=status.HTTP_200_OK)
