import 'package:complex/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:complex/core/ICircularBottom.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key key}) : super(key: key);

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int indexTab = 0;

  String category = "";

  ColorSwatch _tempMainColor;
  ColorSwatch _mainColor = Colors.blue;

  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_setActiveTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setActiveTabIndex() {
    if (_tabController.index != indexTab) {
      setState(() {
        indexTab = _tabController.index;
      });
    }
  }

  void confirmBt() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      await Categoria(
              descripcion: this.category,
              color: this._mainColor.value,
              tipo: (indexTab == 0 ? 'I' : 'E'))
          .save();
      setState(() {});
      Navigator.pop(context);
    } else {
      print('form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Categorias"),
        backgroundColor: indexTab == 0 ? Colors.green : Colors.red,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Column(
            children: <Widget>[
              ICircularBottom(
                height: 15,
                radius: 20,
              ),
              TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  insets: EdgeInsets.all(0),
                ),
                indicatorWeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.all(0),
                tabs: [
                  new Tab(
                    child: Container(
                      color: Colors.white,
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_drop_up,
                            color: Colors.green[(indexTab == 0 ? 600 : 200)],
                          ),
                          Text(
                            'Ingresos',
                            style: Theme.of(context).textTheme.title.copyWith(
                                  color:
                                      Colors.green[(indexTab == 0 ? 600 : 200)],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Tab(
                    child: Container(
                      height: double.infinity,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.red[(indexTab == 1 ? 600 : 200)],
                          ),
                          Text(
                            'Egresos',
                            style: Theme.of(context).textTheme.title.copyWith(
                                  color:
                                      Colors.red[(indexTab == 1 ? 600 : 200)],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //bottomOpacity: 0,
      ),
      body: FutureBuilder<Map<String, List<Categoria>>>(
        future: getCategory(),
        builder: (context, listSnap) {
          if (listSnap.connectionState != ConnectionState.done ||
              listSnap.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: (listSnap.data["ingresos"].length == null
                      ? 0
                      : listSnap.data["ingresos"].length),
                  itemBuilder: (context, index) {
                    Categoria detalle = listSnap.data["ingresos"][index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(detalle.color),
                        child: Text(
                          detalle.descripcion[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(detalle.descripcion),
                      onTap: () {},
                    );
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: (listSnap.data["egresos"].length == null
                      ? 0
                      : listSnap.data["egresos"].length),
                  itemBuilder: (context, index) {
                    Categoria detalle = listSnap.data["egresos"][index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(detalle.color),
                        child: Text(
                          detalle.descripcion[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(detalle.descripcion),
                      onTap: () {},
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
              side: BorderSide(
                  color: (indexTab == 0 ? Colors.green : Colors.red)),
            ),
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateModal) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        child: Text(
                          'Nueva Categoria de ' +
                              (indexTab == 0 ? 'Ingreso' : 'Egreso'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title.copyWith(
                              color:
                                  (indexTab == 0 ? Colors.green : Colors.red),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Divider(
                          height: 20,
                          color: (indexTab == 0 ? Colors.green : Colors.red)),
                      Container(
                        height: MediaQuery.of(context).size.height / 2.8,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingrese el nombre de la categoria';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  icon: Icon(
                                    (indexTab == 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward),
                                    color: (indexTab == 0
                                        ? Colors.green
                                        : Colors.red),
                                  ),
                                  labelText: 'Categoria',
                                ),
                                maxLines: 1,
                                onChanged: (texto) {
                                  category = texto;
                                },
                                //autofocus: true,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.color_lens,
                                    color: (indexTab == 0
                                        ? Colors.green
                                        : Colors.red),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ActionChip(
                                    backgroundColor: this._mainColor,
                                    avatar: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        'C',
                                        style:
                                            TextStyle(color: this._mainColor),
                                      ),
                                    ),
                                    label: Text(
                                      'Color',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _openMainColorPicker(setStateModal);
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              textColor:
                                  (indexTab == 0 ? Colors.green : Colors.red),
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 30, right: 30),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancelar",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            FlatButton(
                              color:
                                  (indexTab == 0 ? Colors.green : Colors.red),
                              textColor: Colors.white,
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 30, right: 30),
                              splashColor:
                                  (indexTab == 0 ? Colors.green : Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: (indexTab == 0
                                        ? Colors.green
                                        : Colors.red)),
                              ),
                              onPressed: () {
                                confirmBt();
                              },
                              child: Text(
                                "Aceptar",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: indexTab == 0 ? Colors.green : Colors.red,
      ),
    );
  }

  Future<Map<String, List<Categoria>>> getCategory() async {
    Map map = new Map<String, List<Categoria>>();
    List<Categoria> ingresos =
        await Categoria().select().tipo.equals('I').toList();
    List<Categoria> egresos =
        await Categoria().select().tipo.equals('E').toList();
    map["ingresos"] = ingresos;
    map["egresos"] = egresos;
    return map;
  }

  void _openDialog(String title, Widget content, StateSetter setStateModal) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('Cancelar'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _mainColor = _tempMainColor;
                });
                setStateModal(() {});
              },
            ),
          ],
        );
      },
    );
  }

  _openMainColorPicker(StateSetter setStateModal) async {
    _openDialog(
        "Color",
        MaterialColorPicker(
          selectedColor: _mainColor,
          allowShades: false,
          onMainColorChange: (color) => setState(() => _tempMainColor = color),
        ),
        setStateModal);
  }
}
