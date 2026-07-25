from dynamic_listing.filters import FilterSet

from apps.ads.models import Ad


class AdsFilter(FilterSet):
    class Meta:
        model = Ad
        fields = {'created_at'}
