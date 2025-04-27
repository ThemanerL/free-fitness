import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/global/constants.dart';
import '../../../common/utils/tool_widgets.dart';
import '../../../layout/themes/cus_font_size.dart';
import '../../../models/cus_app_localizations.dart';

class ExerciseQueryForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onQuery; // 定义回调函数属性

  const ExerciseQueryForm({super.key, required this.onQuery});

  @override
  State<ExerciseQueryForm> createState() => _ExerciseQueryFormState();
}

class _ExerciseQueryFormState extends State<ExerciseQueryForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // 默认只展示精简查询条件
  bool _showAdvancedOptions = false;

  // 点击查询按钮时，把条件表单的数据返回父组件
  void _submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      // 获取查询条件的值
      Map<String, dynamic>? query = _formKey.currentState!.value;

      // 调用回调函数，将查询条件的值传递给上层调用的组件
      widget.onQuery(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          _genSimpleQueryArea(),
        ],
      ),
    );
  }

  // 默认的简单首行，下拉选择锻炼部位和一些按钮
  _genSimpleQueryArea() {
    return Card(
      elevation: 5.sp,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 5.sp, 0, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  // FormBuilderDropdown需要指定外部容器大小，或者放在类似expanded中自动扩展
                  child: cusFormBuilerDropdown(
                    "primary_muscles",
                    musclesOptions,
                    labelText: CusAL.of(context).exerciseQuerys("0"),
                    hintStyle: TextStyle(
                      fontSize: CusFontSizes.searchInputLarge,
                    ),
                    isOutline: true,
                    optionFontSize: CusFontSizes.searchInputLarge,
                  ),
                ),
                Expanded(
                  // 搜索按钮
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.sp),
                    child: SizedBox(
                      // height: 48.sp,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    // todo 如果有高级查询条件被选择，但是被折叠了，点击重置是不会清除的。
                    setState(() {
                      _formKey.currentState!.reset();
                      // 2023-12-12 不知道为什么，reset对下拉选中的没有效，所以手动清除
                      _formKey.currentState?.fields['primary_muscles']
                          ?.didChange(null);
                      _formKey.currentState?.fields['level']?.didChange(null);
                      _formKey.currentState?.fields['mechanic']
                          ?.didChange(null);
                      _formKey.currentState?.fields['category']
                          ?.didChange(null);
                      _formKey.currentState?.fields['equipment']
                          ?.didChange(null);
                    });
                    // 失去焦点
                    unfocusHandle();
                  },
                  child: Text(
                    CusAL.of(context).resetLabel,
                    style: TextStyle(
                      fontSize: CusFontSizes.itemContent,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
