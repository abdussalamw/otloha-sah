import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/core/widgets/action_button.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/user_to_entity_btn/user_to_entity_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/user_to_entitiy_btn.dart';

class EntityCard extends StatelessWidget {
  const EntityCard({super.key, required this.entity});
  final Entity entity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserToEntityBtnCubit(entity: entity),
      child: Column(
        children: [
          Row(
            children: [
              CachedImage(url: entity.logo ?? '', raduis: 35),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entity.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      translate(entity.orgName),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 80,
                height: 30,
                child: UserToEntityBtn(),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[200]!,
            indent: 80,
          ),
        ],
      ),
    );
  }
}
