import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

class TextFieldsView extends StatefulWidget {
  const TextFieldsView({super.key});

  @override
  State<TextFieldsView> createState() => _TextFieldsViewState();
}

class _TextFieldsViewState extends State<TextFieldsView> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text:
          'My code fails, I do not know why.\nMy code works, I do not know why.\nText in other scripts: Tamaziɣt Taqbaylit, 中文(简体), Čeština, Беларуская, Ελληνικά, עברית, Русский, བོད་ཡིག, Norsk bokmål.',
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () {},
              child: const Text(
                'Filled Button',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(
            width: kWrapSpacing,
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Outlined Button',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(
            width: kWrapSpacing,
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
          ),
        ],
      ),
      const TextField(
        enabled: false,
        onChanged: null,
        decoration: InputDecoration(
          labelText: 'Disabled',
        ),
      ),
      const TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
      ),
      const TextField(
        decoration: InputDecoration(
          errorText: "You're doing it wrong",
        ),
      ),
      TextField(
        keyboardType: TextInputType.multiline,
        controller: textController,
        minLines: 5,
        maxLines: 5,
      ),
      const DropdownMenu(
        trailingIcon: Icon(YaruIcons.pan_down),
        selectedTrailingIcon: Icon(YaruIcons.pan_down),
        dropdownMenuEntries: [
          DropdownMenuEntry(value: 1, label: '1'),
          DropdownMenuEntry(value: 2, label: '2'),
          DropdownMenuEntry(value: 3, label: '3'),
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView.separated(
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemCount: children.length,
      ),
    );
  }
}
