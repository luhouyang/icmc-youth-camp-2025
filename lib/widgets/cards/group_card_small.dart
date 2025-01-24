import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/widgets/texts/h1_text.dart';

class GroupCardSmall extends StatefulWidget {
  final GroupEntity groupEntity;

  const GroupCardSmall({super.key, required this.groupEntity});

  @override
  State<GroupCardSmall> createState() => _GroupCardSmallState();
}

class _GroupCardSmallState extends State<GroupCardSmall> {
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
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1Text(
                text: widget.groupEntity.groupName,
              ),
              const Divider(),
              Text(
                widget.groupEntity.score.toString(),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              Text("Protection: ${widget.groupEntity.protection}", style: const TextStyle(fontSize: 12)),
              Text("Mentor: ${widget.groupEntity.mentor}", style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
