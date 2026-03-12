i# Blender Parallel Render

Renderizado paralelo de frames de Blender distribuido entre workers via la plataforma de paralelización.

## Cómo encaja en la plataforma

```
Plataforma de paralelización
  │
  ├── lee config.toml
  │
  └── lanza por cada worker:
        bash render.sh --start 1   --end 25   --output outputs/frames_1_25
        bash render.sh --start 26  --end 50   --output outputs/frames_26_50
        ...
```

## Estructura

```
├── config.toml       # Para la plataforma (inputs · runner · outputs)
├── render.sh         # Worker — llama a Blender CLI, renderiza el chunk
├── Makefile          # Instalación y uso manual
├── tu_escena.blend   # ← pon aquí tu fichero .blend
└── outputs/
    ├── frames_1_25/
    │   ├── 0001.png
    │   └── ...
    └── frames_26_50/
        └── ...
```

## Setup

```bash
make setup    # instala Blender (Linux/macOS)
```

## Uso manual

```bash
make test                    # prueba rápida: frames 1-3
make run START=1 END=50      # renderiza frames 1-50
make clean                   # borra outputs
```

## Configurar frames

Edita `config.toml` para ajustar el rango al total de frames de tu escena:

```toml
[inputs.range_continuous]
start = 1
end   = 250   # ← cambia esto
step  = 1
```
