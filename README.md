# ✈️ Ahorro de Viaje entre Amigos

App web minimalista para registrar y visualizar el ahorro grupal de un viaje.

---

## ⚡ Stack

- **React + Vite** — frontend rápido
- **Supabase** — base de datos + autenticación (sin backend propio)
- **TailwindCSS** — estilos modernos en modo oscuro
- **Vercel** — deploy con un clic

---

## 🚀 Guía de despliegue paso a paso

### 1. Crear proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com) y crea una cuenta
2. Haz clic en **"New project"**
3. Pon un nombre (ej: `ahorro-viaje`) y una contraseña de base de datos
4. Selecciona la región más cercana (ej: `South America (São Paulo)`)
5. Espera a que el proyecto se cree (~1-2 min)

### 2. Ejecutar el SQL

1. En el panel de Supabase, ve a **SQL Editor** (menú izquierdo)
2. Haz clic en **"New query"**
3. Copia y pega todo el contenido del archivo `supabase-setup.sql`
4. Haz clic en **"Run"**
5. Verás las tablas `trips`, `travelers` y `contributions` creadas

### 3. Crear usuario administrador

1. En Supabase, ve a **Authentication** → **Users**
2. Haz clic en **"Add user"** → **"Create new user"**
3. Ingresa el email y contraseña que usará la administradora
4. Haz clic en **"Create user"**

### 4. Obtener las variables de entorno

1. En Supabase, ve a **Project Settings** → **API**
2. Copia:
   - **Project URL** → `VITE_SUPABASE_URL`
   - **anon / public key** → `VITE_SUPABASE_ANON_KEY`

### 5. Configurar el proyecto localmente

```bash
# Clona o descarga el proyecto
cd ahorro-viaje

# Instala dependencias
npm install

# Crea el archivo de variables
cp .env.example .env
```

Edita `.env` con tus valores reales:
```
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGc...
```

### 6. Probar localmente

```bash
npm run dev
```

Abre `http://localhost:5173` — verás la pantalla de login.

### 7. Deploy en Vercel

**Opción A — Vercel CLI:**
```bash
npm install -g vercel
vercel
# Sigue las instrucciones, agrega las env vars cuando te las pida
```

**Opción B — GitHub + Vercel (recomendado):**
1. Sube el proyecto a un repositorio de GitHub
2. Ve a [vercel.com](https://vercel.com) → **"New Project"**
3. Importa tu repositorio
4. En **"Environment Variables"**, agrega:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
5. Haz clic en **"Deploy"**

Vercel detectará automáticamente que es un proyecto Vite.

---

## 📖 Cómo usar la app

### Administradora

1. Entra en la URL del deploy con tu email y contraseña
2. Crea el viaje (nombre, destino, moneda, meta, fecha)
3. Agrega los viajeros con el botón **"+ Viajero"**
4. Registra abonos con **"💰 Registrar abono"**
5. Comparte el enlace público desde **"🔗 Copiar enlace"**

### Viajeros

Solo abren el link compartido — sin login, solo lectura.
Pueden ver totales, progreso, tabla de participantes e historial.

---

## 🗂️ Estructura del proyecto

```
ahorro-viaje/
├── src/
│   ├── components/
│   │   ├── Dashboard.jsx       # Vista principal de stats
│   │   ├── TripForm.jsx        # Formulario crear/editar viaje
│   │   ├── ContributionForm.jsx # Formulario abonos
│   │   └── Modal.jsx           # Modal reutilizable
│   ├── pages/
│   │   ├── LoginPage.jsx       # Login admin
│   │   ├── AdminPage.jsx       # Panel completo
│   │   └── PublicPage.jsx      # Vista pública
│   ├── lib/
│   │   ├── supabase.js         # Cliente Supabase
│   │   └── AuthContext.jsx     # Contexto de autenticación
│   ├── App.jsx                 # Rutas
│   ├── main.jsx                # Entry point
│   └── index.css               # Estilos globales
├── supabase-setup.sql          # Script SQL completo
├── vercel.json                 # Config Vercel (SPA routing)
├── .env.example                # Variables de entorno de ejemplo
└── README.md
```

---

## 🔒 Seguridad

- La base de datos usa **Row Level Security (RLS)** de Supabase
- Lectura pública: cualquier persona con el link puede **ver** los datos
- Escritura restringida: solo usuarios **autenticados** pueden insertar, editar o borrar
- La anon key de Supabase es segura para uso público (solo permite lo que las políticas permiten)

---

## 🐛 Problemas comunes

| Error | Solución |
|---|---|
| "Faltan variables de entorno" | Asegúrate de tener `.env` con las dos variables |
| Login no funciona | Verifica que creaste el usuario en Supabase > Authentication > Users |
| "Viaje no encontrado" en link público | El UUID del link debe coincidir con el trip en la DB |
| Datos no aparecen | Verifica que el SQL se ejecutó correctamente y RLS está activo |
