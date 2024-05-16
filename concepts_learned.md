## Navegación

1. Navigator.push:

Este método se utiliza para agregar una nueva ruta a la pila de navegación. Cuando llamas a Navigator.push, estás diciéndole a la aplicación que agregue una nueva pantalla (o ruta) encima de la pantalla actual. Esto significa que la pantalla actual sigue estando disponible en la pila de navegación y el usuario puede retroceder a ella usando el botón de retroceso del dispositivo o cualquier otro control de navegación que proveas.

2. Navigator.pushReplacement:

Por otro lado, Navigator.pushReplacement se utiliza para reemplazar la ruta actual en la pila de navegación con una nueva ruta. Esto significa que la pantalla actual es eliminada de la pila y reemplazada por la nueva pantalla. Esto puede ser útil cuando deseas que al navegar a una nueva pantalla, la pantalla actual desaparezca y no esté disponible para volver atrás. Por ejemplo, cuando navegas desde una pantalla de inicio de sesión a la pantalla principal de la aplicación, normalmente no querrás que el usuario pueda volver a la pantalla de inicio de sesión una vez que haya iniciado sesión con éxito.