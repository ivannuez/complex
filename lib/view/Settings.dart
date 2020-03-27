import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:complex/core/ICircularBottom.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Configuraciones'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15.0),
          child: ICircularBottom(
            height: 15,
            radius: 20,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 16.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Usuario",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Card(
                        elevation: 0.5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: ExactAssetImage(
                                    'assets/images/icono-app.png'),
                                backgroundColor: Colors.white,
                              ),
                              title: Text("Ivan Nuñez"),
                              onTap: () {},
                            ),
                            _buildDivider(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "Opciones",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Divider(color: Colors.grey),
                      Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                AntDesign.idcard,
                                color: Colors.orange,
                              ),
                              title: Text("Cuentas"),
                              onTap: () {},
                            ),
                            _buildDivider(),
                            ListTile(
                              leading:
                                  Icon(AntDesign.tag, color: Colors.redAccent),
                              title: Text("Categorias"),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/settings/category');
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(AntDesign.clouddownload,
                                  color: Colors.cyan),
                              title: Text("Exportar datos"),
                              onTap: () {},
                            ),
                            _buildDivider(),
                            ListTile(
                              leading:
                                  Icon(AntDesign.sync, color: Colors.green),
                              title: Text("Sincronización"),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 0,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text("Logout"),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 60.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
