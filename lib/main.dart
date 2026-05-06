import 'package:flutter/material.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do MinimaList',
      //identidade visual
      theme: ThemeData (
        useMaterial3: true,
      //esquema de cores
        colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlueAccent,
        brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.white,

              titleTextStyle: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ),
          ),
          cardTheme: CardThemeData (
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
        ),
      home: const TarefaScreen(),
    );
  }
}

// POO - Prog. orientada a obj
class Tarefa {
  final String id;
  final String titulo;
  bool concluida;

  Tarefa ({
    required this.id,
    required this.titulo, 
    this.concluida = false
    });
}

class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});
  @override
  State<TarefaScreen> createState() => _TarefaScreen();
}

class _TarefaScreen extends State<TarefaScreen> {

  final Color _cinza = Colors.grey;
  final Color _azul = Colors.lightBlueAccent;
  final Color _cinzaEscuro = Color(0xFF2D2D2D);
  final Color _branco = Color(0xFFF5F5F5);

  
  final List<Tarefa> _tarefas = [
    Tarefa(id: '1', titulo: 'Comprar pão, leite e ovo'),
    Tarefa(id: '2', titulo: 'Responder e-mails do trabalho', concluida:true),
    Tarefa(id: '3', titulo: 'Acadêmia às 18h'),
  ];

  final TextEditingController _controller = TextEditingController();

  void _abrirBottomSheet(){
    showModalBottomSheet( 
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: _cinza, 
                  borderRadius: BorderRadius.circular(2)),
                )
                
              ),
              Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _cinzaEscuro,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'O que precisa ser feito?',
                  filled: true,
                  fillColor: _branco,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide( color: _azul, width: 2 ),
                  ),
                ),
                onSubmitted: (_) => _adicionarTarefa(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _adicionarTarefa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _azul,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

void _adicionarTarefa() {
  final texto = _controller.text.trim();
  if (texto.isEmpty) return;

  setState( () {
    _tarefas.add(Tarefa(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: texto,
    ));
});
_controller.clear();
Navigator.pop(context);
}

void _alternarStatus(String id){
  setState(() {
    final tarefa = _tarefas.firstWhere((t) => t.id == id);
    tarefa.concluida = !tarefa.concluida;
  });
}

void _deletarTarefa(String id) {
  final index = _tarefas.indexWhere((t) => t.id == id);
  final tarefaRemovida = _tarefas[index];

  setState(() => _tarefas.removeAt(index));
}

  // toda classe que tenha um stateless/ful widget, precisa ter um Widget build(BuildContext context)
  @override
  Widget build(BuildContext context){
    return Scaffold (
      backgroundColor: _branco,

      appBar: AppBar(
        title: Text('2Do MinimaList'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_tarefas.where((t)=> !t.concluida).length} pendentes',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            )
          ),
        ],
      ),
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 80),
          itemCount: _tarefas.length,
          itemBuilder:(context, index) {
            final tarefa = _tarefas[index];

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,

              onDismissed: (_) => _deletarTarefa(tarefa.id),
              child: Card(
                  child: GestureDetector(
                    
                  child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8,
                ),
                leading: Checkbox(
                  value: tarefa.concluida,
                  activeColor: _azul,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  onChanged: (_) => _alternarStatus(tarefa.id),
                ),
                title: Text( 
                  tarefa.titulo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: tarefa.concluida ? TextDecoration.lineThrough : TextDecoration.none,
                    color: tarefa.concluida ? _cinza : _cinzaEscuro,

                  ),
                ),
                subtitle: Text(
                  tarefa.concluida ? 'Concluída' : 'Pendente',
                  style: TextStyle(
                    fontSize: 12,
                    color: tarefa.concluida ? _azul : _cinza,
                  )
                ),
              ),
            ),
            ),
            );
            
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _abrirBottomSheet,
          backgroundColor: _azul,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Nova tarefa'),
        ),
    );
  }
}


