import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../theme/color_palette.dart';
import '../theme/theme_manager.dart';
import 'home_view.dart';

class ChatView extends StatefulWidget {
  final String chatId;
  final String userName;
  const ChatView({super.key, required this.chatId, required this.userName});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;
  bool _isConnected = true;

  // Variables para "está escribiendo"
  Timer? _typingTimer;
  bool _isCurrentlyTyping = false;

  @override
  void initState() {
    super.initState();
    _autorController.text = widget.userName;

    _scrollController.addListener(() {
      final shouldShow = !_isNearBottom();
      if (shouldShow != _showScrollToBottomButton) {
        setState(() {
          _showScrollToBottomButton = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    // Limpiar estado de escritura al salir
    _firebaseService.clearTypingStatus(widget.chatId, widget.userName);
    _scrollController.dispose();
    _controller.dispose();
    _autorController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;

    final position = _scrollController.position;
    final threshold = 200.0; // píxeles desde el final
    return position.maxScrollExtent - position.pixels <= threshold;
  }

  void _toggleConnection() {
    setState(() {
      _isConnected = !_isConnected;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(_isConnected ? 'Reconectado' : 'Desconectado'),
            ],
          ),
          backgroundColor: _isConnected ? verdeMenta : const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Método llamado cuando el usuario escribe en el TextField
  void _onTextChanged(String text) {
    // Solo procesar si está conectado
    if (!_isConnected) return;

    // Si no estaba escribiendo y ahora sí
    if (!_isCurrentlyTyping && text.trim().isNotEmpty) {
      _isCurrentlyTyping = true;
      _firebaseService.setTypingStatus(widget.chatId, widget.userName, true);
    }

    // Cancelar timer anterior
    _typingTimer?.cancel();

    // Si el texto está vacío, marcar como no escribiendo inmediatamente
    if (text.trim().isEmpty) {
      _isCurrentlyTyping = false;
      _firebaseService.setTypingStatus(widget.chatId, widget.userName, false);
      return;
    }

    // Crear nuevo timer - después de 2 segundos sin escribir, marcar como no escribiendo
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isCurrentlyTyping) {
        _isCurrentlyTyping = false;
        _firebaseService.setTypingStatus(widget.chatId, widget.userName, false);
      }
    });
  }

  Widget _buildCompactStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 12),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    color: isDark ? Colors.white60 : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para mostrar "Usuario está escribiendo..."
  Widget _buildTypingIndicator(bool isDark) {
    return StreamBuilder<Map<String, bool>>(
      stream: _firebaseService.getTypingStatus(widget.chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final typingUsers = snapshot.data!;
        final otherUsersTyping =
            typingUsers.entries
                .where((entry) => entry.key != widget.userName && entry.value)
                .map((entry) => entry.key)
                .toList();

        if (otherUsersTyping.isEmpty) return const SizedBox.shrink();

        String text;
        if (otherUsersTyping.length == 1) {
          text = "${otherUsersTyping.first} está escribiendo";
        } else if (otherUsersTyping.length == 2) {
          text =
              "${otherUsersTyping[0]} y ${otherUsersTyping[1]} están escribiendo";
        } else {
          text = "${otherUsersTyping.length} personas están escribiendo";
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar genérico
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.person, size: 18, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              // Contenedor del mensaje con constraints apropiados
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(0xFF2A2A3E).withOpacity(0.7)
                            : const Color(0xFFF0F2F8).withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(6),
                    ),
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color:
                                  isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildTypingDots(isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Animación de puntos para "está escribiendo"
  Widget _buildTypingDots(bool isDark) {
    return SizedBox(
      width: 20,
      height: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3,
          (index) => TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              // Crear un efecto de onda con delay
              final delay = index * 0.2;
              final animValue = ((value + delay) % 1.0);
              final opacity =
                  (0.3 +
                      (0.7 *
                          (0.5 +
                              0.5 *
                                  (animValue < 0.5
                                      ? animValue * 2
                                      : (1 - animValue) * 2))));

              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white70 : Colors.grey.shade600)
                      .withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              );
            },
            onEnd: () {
              // Reiniciar la animación
              if (mounted) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) setState(() {});
                });
              }
            },
          ),
        ),
      ),
    );
  }

  void _mostrarAyuda() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [azulVibrante, verdeMenta],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Cómo usar el chat',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHelpSection('📝 OPERACIONES DISPONIBLES', [
                      '✅ CREAR: Escribe y presiona enviar',
                      '📖 LEER: Los mensajes aparecen automáticamente',
                      '✏️ EDITAR: Mantén presionado tu mensaje',
                      '🗑️ ELIMINAR: Desliza tu mensaje hacia la izquierda',
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildHelpSection('💡 TIPS', [
                      '• TUS mensajes: Aparecen a la DERECHA con fondo azul',
                      '• OTROS mensajes: Aparecen a la IZQUIERDA con fondo gris',
                      '• Solo puedes editar/eliminar TUS mensajes',
                      '• Cada mensaje tiene su avatar al lado',
                      '• Los mensajes editados se marcan como "editado"',
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildHelpSection('📊 ESTADÍSTICAS', [
                      '• En la barra superior: Información del chat',
                      '• En las tarjetas: Estadísticas en tiempo real',
                      '• Se actualiza automáticamente con cada cambio',
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildHelpSection('🌙 TEMA', [
                      '• Icono de luna/sol: Cambio rápido de tema',
                      '• Preferencia guardada automáticamente',
                      '• Adaptación completa claro/oscuro',
                    ], isDark),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulVibrante,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildHelpSection(String title, List<String> items, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE8E9F3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: azulVibrante,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : const Color(0xFF4A5568),
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernMessageBubble(
    dynamic mensaje,
    bool esPropio,
    bool isDark,
  ) {
    return GestureDetector(
      onLongPress: esPropio ? () => _mostrarDialogoEditar(mensaje) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment:
              esPropio ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!esPropio) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [azulVibrante, verdeMenta],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  gradient:
                      esPropio
                          ? LinearGradient(
                            colors: [
                              azulVibrante,
                              azulVibrante.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color:
                      esPropio
                          ? null
                          : isDark
                          ? const Color(0xFF2A2A3E)
                          : const Color(0xFFF0F2F8),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft:
                        esPropio
                            ? const Radius.circular(20)
                            : const Radius.circular(6),
                    bottomRight:
                        esPropio
                            ? const Radius.circular(6)
                            : const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black26
                              : Colors.grey.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!esPropio) ...[
                      Text(
                        mensaje.autor,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: azulVibrante,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      mensaje.texto,
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            esPropio
                                ? Colors.white
                                : isDark
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(
                            mensaje.timestamp,
                          ).toString().substring(11, 16),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                esPropio
                                    ? Colors.white70
                                    : isDark
                                    ? Colors.white54
                                    : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (mensaje.editado) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: verdeMenta.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'editado',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        if (esPropio) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.done_all, size: 12, color: Colors.white70),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (esPropio) ...[
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [azulVibrante, azulVibrante.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _enviarMensaje() async {
    if (!_isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.white),
                SizedBox(width: 8),
                Text('No hay conexión. Conectate para enviar mensajes.'),
              ],
            ),
            backgroundColor: const Color(0xFFFF6B6B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (_controller.text.trim().isNotEmpty) {
      await _firebaseService.enviarMensaje(
        widget.chatId,
        _controller.text.trim(),
        _autorController.text.trim(),
      );
      _controller.clear();

      // Limpiar estado de typing al enviar mensaje
      _typingTimer?.cancel();
      _isCurrentlyTyping = false;
      _firebaseService.setTypingStatus(widget.chatId, widget.userName, false);

      // Scroll al final después de enviar
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Mensaje enviado'),
              ],
            ),
            backgroundColor: verdeMenta,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _mostrarDialogoEditar(mensaje) async {
    final controller = TextEditingController(text: mensaje.texto);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: azulVibrante.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: azulVibrante,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Editar mensaje',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isDark
                          ? const Color(0xFF2A2A3E)
                          : const Color(0xFFE8E9F3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: null,
                autofocus: true,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulVibrante,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );

    if (result != null && result.trim().isNotEmpty && mensaje.id != null) {
      await _firebaseService.actualizarMensaje(
        widget.chatId,
        mensaje.id!,
        result.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Mensaje editado correctamente'),
              ],
            ),
            backgroundColor: verdeMenta,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        titleSpacing: 0,
        leadingWidth: 56,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const HomeView(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
          ),
        ),
        title: Container(
          constraints: const BoxConstraints(maxWidth: 220),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: azulVibrante,
                child: const Icon(Icons.group, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.chatId,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: StreamBuilder(
                            stream: _firebaseService.recibirMensajes(
                              widget.chatId,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final mensajesCount = snapshot.data!.length;
                                return Text(
                                  '$mensajesCount mensajes',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        isDark ? Colors.white60 : Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              return Text(
                                'Cargando...',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? Colors.white60 : Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color:
                                _isConnected
                                    ? verdeMenta
                                    : const Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            constraints: const BoxConstraints(maxWidth: 120),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón de conexión
                IconButton(
                  icon: Icon(
                    _isConnected ? Icons.wifi : Icons.wifi_off,
                    color: _isConnected ? verdeMenta : const Color(0xFFFF6B6B),
                    size: 16,
                  ),
                  onPressed: _toggleConnection,
                  tooltip: _isConnected ? 'Desconectar' : 'Conectar',
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  padding: const EdgeInsets.all(2),
                ),
                Consumer<ThemeManager>(
                  builder: (context, themeManager, child) {
                    return IconButton(
                      icon: Icon(
                        themeManager.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        size: 16,
                      ),
                      onPressed: () async {
                        await themeManager.toggleTheme();
                      },
                      tooltip:
                          themeManager.isDarkMode
                              ? 'Modo Claro'
                              : 'Modo Oscuro',
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      padding: const EdgeInsets.all(2),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    size: 16,
                  ),
                  onPressed: _mostrarAyuda,
                  tooltip: 'Opciones',
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  padding: const EdgeInsets.all(2),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con estadísticas modernizado
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Estadísticas horizontales sobre el nombre
                StreamBuilder(
                  stream: _firebaseService.recibirMensajes(widget.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final mensajes = snapshot.data!;
                      final totalMensajes = mensajes.length;
                      final misMensajes =
                          mensajes
                              .where(
                                (m) => m.autor == _autorController.text.trim(),
                              )
                              .length;
                      final otrosMensajes = totalMensajes - misMensajes;

                      return Row(
                        children: [
                          _buildCompactStatCard(
                            'Total',
                            totalMensajes.toString(),
                            Icons.chat_bubble_outline,
                            azulVibrante,
                            isDark,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactStatCard(
                            'Míos',
                            misMensajes.toString(),
                            Icons.person_outline,
                            verdeMenta,
                            isDark,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactStatCard(
                            'Otros',
                            otrosMensajes.toString(),
                            Icons.people_outline,
                            const Color(0xFF8B5DFF),
                            isDark,
                          ),
                          const Spacer(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 12),
                // Campo de nombre
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(0xFF0F0F23)
                            : const Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isDark
                              ? const Color(0xFF2A2A3E)
                              : const Color(0xFFE8E9F3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _autorController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Tu nombre',
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: azulVibrante.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: azulVibrante,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de mensajes modernizada
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: StreamBuilder(
                stream: _firebaseService.recibirMensajes(widget.chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final mensajes = snapshot.data!;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_isNearBottom()) {
                        _scrollToBottom();
                      }
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      itemCount:
                          mensajes.length + 1, // +1 para el indicador de typing
                      itemBuilder: (context, index) {
                        // Si es el último índice, mostrar el indicador de typing
                        if (index == mensajes.length) {
                          return _buildTypingIndicator(isDark);
                        }
                        final m = mensajes[index];
                        final esPropio =
                            m.autor == _autorController.text.trim();

                        return Dismissible(
                          key: Key(m.id ?? index.toString()),
                          direction:
                              esPropio
                                  ? DismissDirection.endToStart
                                  : DismissDirection.none,
                          background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    backgroundColor:
                                        isDark
                                            ? const Color(0xFF1A1A2E)
                                            : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      'Eliminar mensaje',
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? Colors.white
                                                : const Color(0xFF1A1A2E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      '¿Estás seguro de eliminar este mensaje?',
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? Colors.white70
                                                : Colors.grey,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color:
                                                isDark
                                                    ? Colors.white60
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFFF6B6B,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          onDismissed: (direction) async {
                            if (m.id != null) {
                              await _firebaseService.eliminarMensaje(
                                widget.chatId,
                                m.id!,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Mensaje eliminado'),
                                      ],
                                    ),
                                    backgroundColor: const Color(0xFFFF6B6B),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          child: _buildModernMessageBubble(m, esPropio, isDark),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(azulVibrante),
                    ),
                  );
                },
              ),
            ),
          ),
          // Campo de entrada modernizado
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Campo de texto
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? const Color(0xFF0F0F23)
                              : const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isDark
                                ? const Color(0xFF2A2A3E)
                                : const Color(0xFFE8E9F3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      enabled: _isConnected,
                      style: TextStyle(
                        color:
                            _isConnected
                                ? (isDark
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E))
                                : (isDark ? Colors.white38 : Colors.grey),
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            _isConnected
                                ? 'Escribe un mensaje...'
                                : 'Sin conexión - No puedes enviar mensajes',
                        hintStyle: TextStyle(
                          color:
                              _isConnected
                                  ? (isDark ? Colors.white60 : Colors.grey)
                                  : (isDark
                                      ? Colors.white38
                                      : Colors.grey.shade400),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _isConnected
                                    ? verdeMenta.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _isConnected
                                ? Icons.chat_bubble_outline
                                : Icons.wifi_off,
                            color: _isConnected ? verdeMenta : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onChanged:
                          _onTextChanged, // NUEVO: detectar cuando escribe
                      onSubmitted: (value) async {
                        if (value.trim().isNotEmpty) {
                          await _enviarMensaje();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botón de enviar
                Container(
                  decoration: BoxDecoration(
                    gradient:
                        _isConnected
                            ? LinearGradient(
                              colors: [
                                azulVibrante,
                                azulVibrante.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.grey.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            _isConnected
                                ? azulVibrante.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          _isConnected
                              ? () async {
                                if (_controller.text.trim().isNotEmpty) {
                                  await _enviarMensaje();
                                }
                              }
                              : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        child: Icon(
                          _isConnected ? Icons.send_rounded : Icons.wifi_off,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          _showScrollToBottomButton
              ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [azulVibrante, azulVibrante.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: azulVibrante.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _scrollToBottom,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }
}
