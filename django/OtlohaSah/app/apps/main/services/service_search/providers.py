import operator
from functools import reduce

from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank
from django.db.models import Q

from apps.main.services.service_search.search import SearchAbstract


class SQLSearchProvider(SearchAbstract):
    def search(self, queryset, columns=None, value=''):
        if columns is None:
            columns = []
        q = [Q(**{"{}__icontains".format(column): value}) for column in columns]
        return queryset.filter(reduce(operator.or_, q))

    def ranked_search(self, queryset, search_index, value=''):
        fields = search_index['fields']
        return self.search(queryset, fields, value)


class PostgresSearchProvider(SearchAbstract):
    def search(self, queryset, columns=None, value=''):
        return queryset.annotate(search=SearchVector(*columns)).filter(search=value)

    def get_search_vector(self, fields):
        search_vector = None
        if type(fields) == list:
            search_vector = SearchVector(*fields)
        elif type(fields) == dict:
            for name, weight in fields.items():
                search_vector = SearchVector(name, weight=weight) + search_vector if search_vector \
                    else SearchVector(name, weight=weight)

        return search_vector

    def get_search_query(self, query):
        tokens = query.split(' ')
        search_query = None
        for token in tokens:
            search_query = SearchQuery(token) | search_query if search_query else SearchQuery(token)
        return search_query

    def ranked_search(self, queryset, search_index, value=None):
        search_query = self.get_search_query(value)

        search_vector = self.get_search_vector(search_index['fields'])

        if not search_vector:
            return queryset

        return queryset.annotate(
            search=search_vector,
            rank=SearchRank(search_vector, search_query)
        ).filter(search=search_query).order_by('-rank')
