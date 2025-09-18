# Blawx

A user-friendly web-based tool for Rules as Code written by Jason Morris of [Lexpedite Legal Technologies Ltd.](https://lexpedite.ca).

Blocks + law = Blawx

![Blawx Front End Screenshot](blawx_v1.6.16-alpha_interface.png)

## Demonstration Video

Click on the thumbnail below for a recent
video demonstration of how Blawx is used.

[![thumbnail](thumbnail.png)](https://youtu.be/x5l4Ynfr4VU)

## Overview

### What is "Rules as Code"?

Rules as Code is the idea that if you write rules in a programming language at the same time you write them in a natural language,
you end up with better rules, and you make it easier for people to automate implementations of those rules.

I believe:

1. The best tools for doing knowledge representation of laws are declarative logic programming languages.
2. Rules as Code requires tools that make it easy for non-programmers to do legal knowledge representation.
3. Tools for Rules as Code must be accessible, and transparent, which means they need to be open source.

## What is Blawx?

Blawx is an open source, user-friendly, web-based declarative logic knowledge representation tool
designed specifically for encoding, testing and using rules.

It is implemented as a set of applications.

It provides:

- a web server that stores your Blawx encodings and gives access to them and the reasoner over a RESTful API, based on [Django](https://www.djangoproject.com/)
- a visual development environment based on [Google's Blockly](https://github.com/google/blockly)
  to write, edit, and test your encodings
- a reasoner based on [SWI-Prolog](https://swi-prolog.org/) and [s(CASP)](https://github.com/JanWielemaker/sCASP) that will answer questions and explain the answers

### Why Should I Use Blawx?

- Open Source
- Easy to Learn
- Designed Specifically for Rules as Code
- Publish Code as an API
- Explainability
- Hypothetical reasoning
- User-friendly Scenario Explorer

Blawx is the only open source Rules as Code programming environment with
a user-friendly scenario explorer, explanations for answers, and hypothetical reasoning.

## How do I Install It Myself?

If you would like to try running Blawx locally, install docker for your platform, and then run

```
docker run lexpedite/blawx
```

Blawx will then be available at (http://localhost:8000)[http://localhost:8000].

Check out [INSTALL.md](INSTALL.md) for more details.

## How Can I Learn More?

Extensive documentation is available from inside the application
by clicking "Help" in the left navigation menu. You can also view the [documentation on the live demo site](https://dev.blawx.com/docs).

## Is this software production ready?

No. Blawx is functional, but it is not production-quality software. It is intended for educational and experimental purposes.

## Running Blawx Locally for Development

### Option 1: GitHub Codespaces (Recommended)

The easiest way to run Blawx for development is using GitHub Codespaces:

1. **Create a Codespace in VS Code:**
   - Install the [GitHub Codespaces extension](https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces) in VS Code
   - Open VS Code and press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) to open the Command Palette
   - Type "Codespaces: Create New Codespace" and select it
   - Choose the repository: `cds-snc/blawx`
   - Select your desired branch (typically `main`)
   - Choose machine type (2-core is sufficient for development)
   - VS Code will automatically connect to your new codespace

2. **Set up the development environment:**
   ```bash
   make setup
   ```
   This command will:
   - Install Python dependencies
   - Create necessary directories
   - Install npm dependencies
   - Download static files (Blockly, Bootstrap, etc.)
   - Run database migrations
   - Load initial data
   - Collect static files

3. **Run the development server:**
   ```bash
   make run
   ```
   The application will be available at `http://localhost:8000`

### Option 2: Local Development

If you prefer to run Blawx on your local machine:

1. **Prerequisites:**
   - Python 3.8+
   - Node.js 14+
   - SWI-Prolog
   - PostgreSQL development libraries (for psycopg2)
     - **macOS:** `brew install postgresql`
     - **Ubuntu/Debian:** `sudo apt-get install postgresql-dev libpq-dev python3-dev`
     - **CentOS/RHEL:** `sudo yum install postgresql-devel python3-devel`
   - Git

2. **Clone and setup:**
   ```bash
   git clone https://github.com/cds-snc/blawx.git
   cd blawx
   make setup
   ```

3. **Run the development server:**
   ```bash
   make run
   ```

### Additional Make Commands

- `make help` - Show all available commands
- `make migrate` - Run database migrations
- `make load-data` - Load initial test data
- `make test` - Run the test suite
- `make lint` - Run code linting
- `make clean` - Clean up temporary files

### Development Notes

- The development server runs on `http://localhost:8000`
- Admin interface is available at `http://localhost:8000/admin/`
- The application uses SQLite by default for development
- Static files are served from the `static/` directory
- The Codespace environment includes all necessary dependencies pre-installed

## Contributions

If you have issues or concerns with the package, please open an Issue in the [GitHub Repository](https://github.com/Lexpedite/blawx).
Contributions to the code and documentation are welcome. Please contribute responsibly.
