import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/modules/entities/cubit/entities_cubit.dart';
import 'package:otloha_sah_flutter/modules/entities/presentation/widgets/entity_card.dart';

class EntitiesListingPage extends StatefulWidget {
  const EntitiesListingPage({super.key, required this.pagingController});
  final PagingController pagingController;

  @override
  State<EntitiesListingPage> createState() => _EntitiesListingPageState();
}

class _EntitiesListingPageState extends State<EntitiesListingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => EntitiesCubit(),
      child: BlocBuilder<EntitiesCubit, EntitiesState>(
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
              pagingController: widget.pagingController,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
