import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/widgets/texts/h1_text.dart';

class GroupCardLarge extends StatefulWidget {
  final bool isLogin;
  final GroupEntity groupEntity;

  const GroupCardLarge({super.key, required this.groupEntity, required this.isLogin});

  @override
  State<GroupCardLarge> createState() => _GroupCardLargeState();
}

class _GroupCardLargeState extends State<GroupCardLarge> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {},
      onTap: () {},
      borderRadius: BorderRadius.circular(8.0),
      splashColor: Theme.of(context).highlightColor.withOpacity(0.5),
      highlightColor: Theme.of(context).highlightColor.withOpacity(0.5),
      focusColor: Theme.of(context).highlightColor.withOpacity(0.5),
      child: Card(
        color: Theme.of(context).highlightColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1Text(
                text: widget.groupEntity.groupName,
              ),
              const Divider(),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.groupEntity.score.toString(),
                style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              const Divider(),
              // if (widget.isLogin) Text("Protection: ${widget.groupEntity.protection}", style: const TextStyle(fontSize: 20)),
              Text("Mentor: ${widget.groupEntity.mentor}", style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
