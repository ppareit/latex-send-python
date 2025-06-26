# latex-send-python

> **Send Python snippets embedded in your LaTeX documents straight to a live REPL, all without leaving Emacs.**

[![License: GPL‑3.0](https://img.shields.io/badge/license-GPL‒3.0-blue.svg)](LICENSE)

---

## Features

* **Literate workflow** – run the code that sits in your `lstlisting`, `minted`, `pycode` or `\lstinline` blocks while you write.
* **Zero‑setup** – a single `.el` file that relies only on AUCTeX/LaTeX‑mode and the built‑in `python.el`.
* **Smart target selection** – with point inside a code block the *whole* block is sent; with an active region only the region is sent.
* **Automatic REPL management** – starts `python-shell` (or `ipython` when configured) if none is running and re‑uses the existing one otherwise.

---

## Installation

### Using `straight.el` & `use-package` (recommended)

```emacs-lisp
(use-package latex-send-python
  :straight (:host github :repo "ppareit/latex-send-python")
  :after (latex python) ; make sure both modes are loaded first
  :bind (:map LaTeX-mode-map
              ("C-c C-c" . latex-send-python)))
```

### Via `package.el`

```bash
M-x package-install-file RET
/path/to/latex-send-python.el RET
```

### Manual

1. Clone the repository:

   ```bash
   git clone https://github.com/ppareit/latex-send-python.git
   ```
2. Add the directory to your `load-path` and require the file:

   ```emacs-lisp
   (add-to-list 'load-path "~/path/to/latex-send-python")
   (require 'latex-send-python)
   ```

---

## Usage

1. Open a `.tex` file that contains Python code blocks.
2. Place the point **inside** the desired block *or* select a region.
3. Hit `C-c C-c` *(or run `M-x latex-send-python`)*.

| Where is the point?        | What gets sent to the shell? |
|----------------------------|------------------------------|
| Inside a `lstlisting` env. | The full environment         |
| Inside `\lstinline`        | The inline expression        |
| Active region              | The region only              |

If no shell is running one is spawned automatically using the interpreter set in `python-shell-interpreter` (`ipython` is honoured).

### Handy tips

* When using `ipython`, enable `%autoreload` for a smoother experience.
* Combine with AUCTeX’s `TeX-command-master` for a tight *write–run–compile* loop.

---

## Customization

Non at the moment, but let me know if something needs customization!

---

## Known Issues

* On Emacs 29+ the *first* invocation can throw an "unexpected prompt" error coming from `python.el`. Calling the command again fixes the session.
* Currently only `lstlisting` and `lstinline` are detected. Other code‑friendly environments (e.g. `verbatim`) could be added. PRs welcome!

---

## Contributing

Bug reports, feature requests and pull requests are warmly welcome.

1. Fork the repository and create your branch (`git checkout -b feature/foo`).
2. Commit your changes with clear messages (`git commit -am 'Add foo'`).
3. Push the branch (`git push origin feature/foo`) and open a PR.

---

## Support

If this package saves you time you can buy the maintainer a coffee via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ZBVLYKWYMXQ3G).

---

## License

This project is distributed under the terms of the **GNU General Public License, version 3**. See the [LICENSE](LICENSE) file for details.
