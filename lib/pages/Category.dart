import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:complex/constant/Widget.dart';
import 'package:complex/model/model.dart';

class Category extends StatefulWidget {
  Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TabController _tabController;
  int indexTab = 0;

  Categoria current = new Categoria();

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

  void setData(Categoria selected) {
    current = selected;
    viewModal(editing: true);
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

  void _setActiveTabIndex() {
    if (_tabController.index != indexTab) {
      setState(() {
        indexTab = _tabController.index;
      });
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
                  Tab(
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
                  Tab(
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
                      onTap: () {
                        setData(detalle);
                      },
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
                      onTap: () {
                        setData(detalle);
                      },
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
          viewModal(editing: false);
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: indexTab == 0 ? Colors.green : Colors.red,
      ),
    );
  }

  void viewModal({bool editing}) {
    if (!editing) {
      current = new Categoria();
      current.color = Colors.blue.value;
      current.tipo = (indexTab == 0 ? 'I' : 'E');
    }
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
        side: BorderSide(color: (indexTab == 0 ? Colors.green : Colors.red)),
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
                        color: (indexTab == 0 ? Colors.green : Colors.red),
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Divider(
                    height: 20,
                    color: (indexTab == 0 ? Colors.green : Colors.red)),
                Container(
                  height: MediaQuery.of(context).size.height / 2.8,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: FormBuilder(
                    key: _fbKey,
                    autovalidate: false,
                    child: Column(
                      children: <Widget>[
                        FormBuilderTextField(
                          keyboardType: TextInputType.text,
                          initialValue: current.descripcion,
                          attribute: "descripcion",
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.description,
                              color: Colors.lime,
                            ),
                            hintText: 'Descripcion',
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          validators: [
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido.'),
                          ],
                          onChanged: (value) {
                            current.descripcion = value;
                          },
                        ),
                        FormBuilderColorPicker(
                          colorPickerType: ColorPickerType.MaterialPicker,
                          initialValue: Color(current.color),
                          attribute: 'color',
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.color_lens,
                              color: Colors.orange,
                            ),
                            hintText: 'Color',
                          ),
                          onChanged: (value) {
                            Color val = value;
                            current.color = val.value;
                          },
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
                        color: Colors.transparent,
                        textColor: (indexTab == 0 ? Colors.green : Colors.red),
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
                      RaisedButton(
                        color: (indexTab == 0 ? Colors.green : Colors.red),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 30, right: 30),
                        splashColor:
                            (indexTab == 0 ? Colors.green : Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          side: BorderSide(
                              color:
                                  (indexTab == 0 ? Colors.green : Colors.red)),
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
  }

  void confirmBt({bool editting}) async {
    final form = _fbKey.currentState;
    if (form.validate()) {
      current.save();
      setState(() {});
      Navigator.pop(context);
    } else {
      print('form is invalid');
    }
  }
}
