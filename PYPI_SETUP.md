# Guía de Publicación en PyPI

## Paso 1: Crear cuenta en PyPI (si no tienes)

1. Ve a https://pypi.org/account/register/
2. Regístrate con tu email
3. Verifica tu email

## Paso 2: Crear un API Token

1. Ve a https://pypi.org/manage/account/token/
2. Crea un nuevo token con el nombre "odooclaw-mcp"
3. Scope: "Entire account" (para este primer paquete)
4. **COPIA EL TOKEN** - solo se muestra una vez
5. Guárdalo en un lugar seguro

## Paso 3: Configurar twine con el token

Crea el archivo ~/.pypirc con:

```ini
[pypi]
username = __token__
password = pypi-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

(Reemplaza las AAAAAAAAA... con tu token real)

## Paso 4: Construir el paquete

```bash
cd /Users/Shared/PROYECTOS/odooclaw-mcp
python3 -m build
```

Esto creará los archivos en `dist/`:
- odooclaw_mcp-2.1.0-py3-none-any.whl
- odooclaw_mcp-2.1.0.tar.gz

## Paso 5: Verificar el paquete

```bash
twine check dist/*
```

## Paso 6: Subir a PyPI

```bash
twine upload dist/*
```

## Paso 7: Verificar

Ve a:
- https://pypi.org/project/odooclaw-mcp/
- Deberías ver tu paquete publicado

## Troubleshooting

### Error: "Project already exists"
Significa que el nombre del paquete ya está registrado. Tendrás que cambiar el nombre en pyproject.toml.

### Error: "403 Forbidden"
Tu token no tiene permisos suficientes. Verifica que el scope sea "Entire account".

### Error: "Invalid or non-existent authentication information"
Verifica que ~/.pypirc esté correcto con el token válido.

### Error: "File already exists"
Significa que ya existe una versión 2.1.0. Tendrás que cambiar la versión a 2.1.1 o superior.
