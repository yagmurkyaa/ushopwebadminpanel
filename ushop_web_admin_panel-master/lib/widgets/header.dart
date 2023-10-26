import 'package:flutter/material.dart';
import 'package:ushop_admin_panel/responsive.dart';
import 'package:ushop_admin_panel/services/utils.dart';
import 'package:ushop_admin_panel/consts/constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    required this.fct,
    this.showTextField = true,
  }) : super(key: key);

  final String title;
  final Function fct;
  final bool showTextField;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return Row(
      children: [
        //First if is for mobile screen, second if for desktop screen
        //1: only icon 2:Dashboard text
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (Responsive.isDesktop(context)) //desktop modunda search kısmını küçültür
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          !showTextField
              ? Container()
              : Expanded( // to not make an overflow error
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      fillColor: Colors.yellow[700]?.withOpacity(0.8),//Theme.of(context).cardColor,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {

                        },
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding * 0.75),
                          margin: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          decoration: const BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.search,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}