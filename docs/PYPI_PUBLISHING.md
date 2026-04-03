# 📦 Publicando Odoo MCP Server en PyPI

## ¿Qué es PyPI?

PyPI (Python Package Index) es el repositorio oficial de paquetes de Python, donde millones de desarrolladores buscan e instalan librerías.

**URL**: https://pypi.org/project/odoo-mcp/

## 📋 Requisitos Previos

1. ✅ **Paquete construido** - Ya hecho
2. **Cuenta de PyPI** - Necesitas crear una

## 🚀 Paso 1: Crear Cuenta en PyPI

Si no tienes cuenta:

1. Ve a: https://pypi.org/account/register/
2. Regístrate con tu email
3. Verifica tu email
4. Activa la autenticación de dos factores (2FA) - **OBLIGATORIO** para publicar

## 🔐 Paso 2: Crear API Token

PyPI requiere un API token para subir paquetes:

1. Ve a: https://pypi.org/manage/account/token/
2. Crea un nuevo token:
   - **Nombre**: `odoo-mcp-release`
   - **Alcance**: "Entire account" (para publicar paquetes)
3. **Copia el token** - Solo lo verás una vez, guárdalo en un lugar seguro

## 📦 Paso 3: Publicar el Paquete

### Opción 1: Usar el Script Automatizado

El script ya está preparado en `/Users/Shared/PROYECTOS/odoo-mcp/scripts/publish_to_pypi.sh`

### Opción 2: Manualmente

```bash
cd /Users/Shared/PROYECTOS/odoo-mcp

# Configurar Twine con tu token
python3 -m twine config upload create 

# O subir con usuario y contraseña
python3 -m twine upload dist/* 
```

## ⚠️ Antes de Publicar

### Verificar disponibilidad del nombre

```bash
# Verificar si "odoo-mcp" está disponible
curl https://pypi.org/pypi/odoo-mcp/json
```

Si devuelve 404, el nombre está disponible ✅

### Verificar el paquete

```bash
python3 -m twine check dist/*
```

## 🎯 Proceso de Publicación

Cuando estés listo:

```bash
cd /Users/Shared/PROYECTOS/odoo-mcp

# Limpiar builds anteriores
rm -rf dist/ build/ *.egg-info

# Reconstruir
python3 -m build

# Verificar
python3 -m twine check dist/*

# Subir a TestPyPI primero (opcional pero recomendado)
python3 -m twine upload --repository testpypi dist/*

# Subir a PyPI production
python3 -m twine upload dist/*
```

## ✅ Después de Publicar

### Verificar instalación

```bash
# En una terminal limpia
pip3 install odoo-mcp

# Verificar que funciona
python3 -c "import odoo_mcp; print(odoo_mcp.__version__)"
```

### Tu URL en PyPI

Los usuarios podrán instalar con:
```bash
pip install odoo-mcp
```

Y verán tu documentación en:
https://pypi.org/project/odoo-mcp/

## 🔄 Actualizaciones Futuras

Para lanzar nuevas versiones:

1. Actualizar `version` en `pyproject.toml`
2. Actualizar `CHANGELOG.md`
3. Crear git tag: `git tag -a v1.0.1 -m "Release v1.0.1"`
4. Construir: `python3 -m build`
5. Publicar: `python3 -m twine upload dist/*`

## 📚 Recursos

- **PyPI**: https://pypi.org/
- **Twine Documentation**: https://twine.readthedocs.io/
- **PyPI Publishing Guide**: https://packaging.python.org/tutorials/packaging-projects/

---

**¿Listo para publicar en PyPI?**

Necesitas:
1. ✅ Cuenta de PyPI
2. ✅ API Token de PyPI
3. ✅ Ejecutar: `./scripts/publish_to_pypi.sh`

¡Vamos a por ello! 🚀
