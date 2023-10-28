import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class RefreshCustomWidget extends StatelessWidget {
  const RefreshCustomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text("برای بیشتر بکشید");
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = const Text("خطا");
        } else if (mode == LoadStatus.canLoading) {
          body = const Text("رها کنید");
        } else {
          body = const Text("بیشتر نیست");
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
