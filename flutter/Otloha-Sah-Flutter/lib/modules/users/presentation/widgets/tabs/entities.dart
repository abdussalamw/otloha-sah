import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/modules/entities/cubit/entities_cubit.dart';
import 'package:otloha_sah_flutter/modules/entities/presentation/widgets/entity_card.dart';

class EntitiesList extends StatefulWidget {
  const EntitiesList({super.key});

  @override
  State<EntitiesList> createState() => _EntitiesListState();
}

class _EntitiesListState extends State<EntitiesList>
    with AutomaticKeepAliveClientMixin {
  final PagingController<int, Entity> pagingController =
      PagingController<int, Entity>(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<EntitiesCubit, EntitiesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationData<Entity>(
            getData: (nextLink) async {
              return await BlocProvider.of<EntitiesCubit>(context)
                  .getNextPage(nextLink);
            },
            drowItem: (results, index) {
              return EntityCard(entity: results);
            },
            initData: const [],
            pagingController: pagingController,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
