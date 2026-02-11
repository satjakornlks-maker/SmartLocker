import 'package:flutter/material.dart';
import 'package:untitled/screens/common/chose_size_page/chose_size_component/chose_size_bottom.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/grid/HoverMenuCard.dart';
import '../../../input_type_page/input_type_page/input_type_page.dart';
import '../../../locker_page/locker_selection_page.dart';

class ChoseSizeMainContent extends StatelessWidget {
  final LockerSelectionMode? mode;
  final FromPage? from;
  const ChoseSizeMainContent({super.key, this.mode, this.from});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.choseLockerType,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: HoverMenuCard(
                    titleTh: Text(AppLocalizations.of(context)!.small,textAlign: .center,),
                    icon: Icons.home_work,
                    color: Colors.blue,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mode != null
                            ? LockerSelectionPage(mode: mode!, size: 'small')
                            : InputTypePage(from: from!, size: 'small'),
                      ),
                    ),
                    haveIcon: false,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: HoverMenuCard(
                    titleTh: Text(AppLocalizations.of(context)!.medium,textAlign: .center,),
                    icon: Icons.person,
                    color: Colors.blue,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mode != null
                            ? LockerSelectionPage(mode: mode!, size: 'medium')
                            : InputTypePage(from: from!, size: 'medium'),
                      ),
                    ),
                    haveIcon: false,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: HoverMenuCard(
                    titleTh: Text(AppLocalizations.of(context)!.large,textAlign: .center,),
                    icon: Icons.person,
                    color: Colors.blue,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mode != null
                            ? LockerSelectionPage(mode: mode!, size: 'large')
                            : InputTypePage(from: from!, size: 'large'),
                      ),
                    ),
                    haveIcon: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const ChoseSizeBottom()
          ],
        ),
      ),
    );
  }
}
