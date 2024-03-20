import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> formatList = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.orange1),
      body: SafeArea(
        bottom: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              Text(
                'Replacer',
                style: MyTextStyles.title,
              ),
              const SizedBox(height: 100),
              Container(
                  // width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(MyColors.orange1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(MyColors.light),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NewReplace',
                        style: MyTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/replace_edit_page');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(MyColors.light),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Edit', style: MyTextStyles.subtitleOrange),
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 100),
              Expanded(
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(MyColors.orange1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      border: Border(
                        top: BorderSide(color: Color(MyColors.light), width: 2),
                        left: BorderSide(color: Color(MyColors.light), width: 2),
                        right: BorderSide(color: Color(MyColors.light), width: 2),
                      ),
                    ),
                    child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        itemCount: formatList.length,
                        itemBuilder: (context, index) {
                          return _gridItem(index);
                        },
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          // childAspectRatio: 2.0,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridItem(int index) {
    return Container(
      height: 200,
      margin:
          EdgeInsets.only(top: 12, bottom: index == formatList.length - 1 || index == formatList.length - 2 ? 20 : 0),
      decoration: BoxDecoration(
        color: const Color(MyColors.orange1),
        border: Border.all(
          color: const Color(MyColors.light),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(formatList[index])),
    );
  }
}
