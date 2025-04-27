import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../common/utils/tools.dart';
import '../models/cus_app_localizations.dart';
import '../views/training/index.dart';

/// 主页面

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initPermission();
  }

  initPermission() async {
    var state = await requestStoragePermission();

    if (!state) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(CusAL.of(context).permissionRequest),
            content: Text(CusAL.of(context).featuresRestrictionNote),
            actions: <Widget>[
              TextButton(
                child: Text(CusAL.of(context).cancelLabel),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                child: Text(CusAL.of(context).confirmLabel),
                onPressed: () async {
                  var state = await requestStoragePermission();
                  if (!context.mounted) return;
                  Navigator.of(context).pop(state);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value == false) {
          if (!mounted) return;
          EasyLoading.showToast(CusAL.of(context).noStorageHint);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // 点击返回键时暂停返回
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        // 如果确认弹窗点击确认返回true，否则返回false
        final bool? shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(CusAL.of(context).closeLabel),
              content: Text(CusAL.of(context).appExitInfo),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(CusAL.of(context).cancelLabel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(CusAL.of(context).confirmLabel),
                ),
              ],
            );
          },
        ); // 只有当对话框返回true 才 pop(返回上一层)
        if (shouldPop ?? false) {
          // 如果还有可以关闭的导航，则继续pop
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            // 如果已经到头来，则关闭应用程序
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(CusAL.of(context).training),
          centerTitle: true,
        ),
        body: const Training(),
      ),
    );
  }
}
