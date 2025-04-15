;;; mjj-publish.el --- MJJ publishing machinery  -*- lexical-binding: t; -*-
;;; Commentary:
;; The static website generator for MonkeyJungleJuice
;;; Code:

;;  ____________________________________________________________________________
;;; DEV WEBSERVER

(defun mjj-launch-shell (command name)
  "Launch programs via shell COMMAND. The NAME can be an arbitrary string.
The sub-process can be managed via `list-processes'"
  (start-process-shell-command
   name
   (concat "*Process " name "*")     ; with named buffer or `nil' without buffer
   command)
  (message (concat "Launching shell command " name "...done")))

;; TODO: Put the webserver project and binary into the blog directory
(defun mjj-webserver-build ()
  "(Re)build the webserver binary.
The webserver is an Elixir application and requires a working Erlang/Elixir
installation."
  (interactive)
  (message "TODO: Not implemented yet!"))

(defun mjj-webserver-start ()
  "Launch the webserver at <http://localhost:50081/index.html>.
The port is still hardcoded in the Elixir app and may have changed."
  (interactive)
  (start-process-shell-command
   "MJJ Webserver"
   "*Process MJJ Webserver*"  ; with named buffer or `nil' without buffer
   (concat mjj-root
           "static/webserver/_build/prod/rel/webserver/bin/webserver start"))
  (message (concat "MJJ: Launching webserver...done" "")))

(defun mjj-webserver-stop ()
  "Stop the webserver at <http://localhost:50081/index.html>."
  (interactive)
  (start-process-shell-command
   "MJJ Webserver"
   nil
   (concat mjj-root
           "static/webserver/_build/prod/rel/webserver/bin/webserver stop"))
  (message (concat "MJJ: Stopping webserver...done" "")))

;;  ____________________________________________________________________________
;;; ORG EXPORT AND PUBLISHING

(use-package org
  :defer t
  :config
  ;; Additional structure templates for Org blocks
  (cl-pushnew '("n" . "nav") org-structure-template-alist)
  (cl-pushnew '("m" . "message") org-structure-template-alist)
  (cl-pushnew '("i" . "index") org-structure-template-alist)
  (cl-pushnew '("t" . "tree") org-structure-template-alist)
  (cl-pushnew '("b" . "box") org-structure-template-alist))

;; <https://orgmode.org/manual/Publishing.html>
(use-package ox-publish)

;; <https://orgmode.org/manual/HTML-Export.html>
(use-package ox-html
  :defer t)

;; <https://github.com/hniksic/emacs-htmlize>
(use-package htmlize
  :defer t
  :config
  ;; Set external 'css' or 'inline-css' for code snippets created by htmlize
  ;; CSS file can be generated with 'org-html-htmlize-generate-css'
  (setq org-html-htmlize-output-type 'css))

;; Prevent littering the recently visited files with exported HTML
(use-package recentf
  :defer t
  :config
  (cl-pushnew (expand-file-name "../.*\\.html$")
              recentf-exclude))

;; Don't show day and hour
;; (setq org-html-metadata-timestamp-format "%Y-%m-%d")

;;  ____________________________________________________________________________
;;; PAGE TEMPLATE

(defvar mjj-page-html-head nil "Lines to include in <head>...</head> specific to pages.")
(setq mjj-page-html-head
      (concat
       "<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'self'; script-src 'self' https://wa.skred.net/; connect-src https://wa.skred.net/; style-src 'self' https://*; img-src 'self' https://*; media-src 'self' https://*;\">\n"
       "<meta name=\"google-site-verification\" content=\"WUje0h1DXIUXINogHFZva1zk3Lw1oSpgrqva9dubYq0\">\n"
       "<link rel=\"stylesheet\" href=\"/static/normalize.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/org.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/style.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/iosevka-etoile/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/cormorant/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/gentium-basic/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/iosevka-aile/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/iosevka/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"icon\" type=\"image/svg+xml\" href=\"/static/monkeyjunglejuice.svg\">\n"
       "<link rel=\"apple-touch-icon\" href=\"/static/monkeyjunglejuice-icon180.png\">\n"
       "<script defer src=\"/static/header.js\"></script>\n"))

(defvar mjj-page-preamble nil "Header for pages.")
(setq mjj-page-preamble
      (concat
       "<nav id=\"nav-primary\">"
       "<a id=\"site-name\" href=\"/index.html\">MonkeyJungleJuice</a>"
       " "
       "<a id=\"bio\" href=\"/bio.html\">Bio</a>"
       "<a id=\"github\" href=\"https://github.com/monkeyjunglejuice\">Github</a>"
       "</nav>"))

(defvar mjj-page-postamble nil "Footer for pages.")
(setq mjj-page-postamble
      (concat
       "<div class=\"footer\">Published by <span class=\"author\"><a href=\"/bio.html\">%a</a></span></div>\n"
       "<script defer src=\"/static/footer.js\"></script>"))

;;  ____________________________________________________________________________
;;; BLOG TEMPLATE

(defvar mjj-blog-html-head nil "Lines to include in <head>...</head> specific to blog articles.")
(setq mjj-blog-html-head
      (concat
       "<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'self'; script-src 'self' https://wa.skred.net/; connect-src https://wa.skred.net/; style-src 'self' https://*; img-src 'self' https://*; media-src 'self' https://*;\">\n"
       "<link rel=\"stylesheet\" href=\"/static/normalize.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/org.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/style.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/iosevka-etoile/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/cormorant/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/gentium-basic/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/iosevka-aile/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/iosevka/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"icon\" type=\"image/svg+xml\" href=\"/static/monkeyjunglejuice.svg\">\n"
       "<link rel=\"apple-touch-icon\" href=\"/static/monkeyjunglejuice-icon180.png\">\n"
       "<script defer src=\"/static/header.js\"></script>"))

(defvar mjj-blog-preamble nil "Header for blog articles.")
(setq mjj-blog-preamble
      (concat
       "<nav id=\"nav-primary\">"
       "<a id=\"site-name\" href=\"/index.html\">MonkeyJungleJuice</a>"
       " "
       "<a id=\"bio\" href=\"/bio.html\">Bio</a>"
       "<a id=\"github\" href=\"https://github.com/monkeyjunglejuice\">Github</a>"
       "</nav>\n"
       "<div class=\"info\"><time itemprop=\"dateModified\" datetime=\"%C\">Last updated: %C</time></div>"))

(defvar mjj-blog-postamble nil "Footer for blog articles.")
(setq mjj-blog-postamble
      (concat
       "<div class=\"footer\">Published by <span class=\"author\"><a href=\"/bio.html\">%a</a></span></div>\n"
       "<script defer src=\"/static/footer.js\"></script>"))

;;  ____________________________________________________________________________
;;; EXPORT SETTINGS
;; To export several files at once to a specific directory, either
;; locally or over the network, you must define a list of projects through
;; the variable ‘org-publish-project-alist’.

;; Each item in the `org-publish-project-alist' is considered a "project".
;; Projects can be components of a superordinate project.

;; Reference of all properties: "C-h v org-publish-project-alist"

;; Group projects into a superordinate project
(cl-pushnew `("mjj"
              :components ("mjj-page" "mjj-blog"))
            org-publish-project-alist)

;;; PAGES project
(cl-pushnew `("mjj-page"
              :base-directory ,mjj-root
              :base-extension "org"
              :exclude "draft"
              :publishing-directory ,mjj-root
              :publishing-function org-html-publish-to-html
              :headline-levels 6
              :section-numbers nil
              :auto-sitemap nil
              :preserve-breaks t
              :with-title t
              :with-toc nil
              :with-smart-quotes t
              :with-drawers nil
              :html-doctype "html5"
              :html-html5-fancy t
              :html-toplevel-hlevel 2
              :html-metadata-timestamp-format "%Y-%m-%d"
              :html-head ,mjj-page-html-head
              :html-head-include-scripts nil
              :html-head-include-default-style nil
              :html-preamble ,mjj-page-preamble
              :html-postamble ,mjj-page-postamble
              )
            org-publish-project-alist)

;;; BLOG ARTICLES project
(cl-pushnew `("mjj-blog"
              :base-directory ,(concat mjj-root "blog/")
              :base-extension "essay.org\\|howto.org\\|tutorial.org\\|walktrough.org\\|project.org"
              :exclude "draft"
              :publishing-directory ,(concat mjj-root "blog/")
              :publishing-function org-html-publish-to-html
              :headline-levels 6
              :section-numbers nil
              :auto-sitemap nil
              :preserve-breaks t
              :with-title t
              :with-toc nil
              :with-smart-quotes t
              :with-drawers nil
              :html-doctype "html5"
              :html-html5-fancy t
              :html-toplevel-hlevel 2
              :html-metadata-timestamp-format "%Y-%m-%d"
              :html-head ,mjj-blog-html-head
              :html-head-include-scripts nil
              :html-head-include-default-style nil
              :html-preamble ,mjj-blog-preamble
              :html-postamble ,mjj-blog-postamble
              )
            org-publish-project-alist)

;;; Export the Protoverse whitepaper from blog to the project directory
(cl-pushnew `("protoverse"
              :base-directory ,(concat mjj-root "blog/")
              :base-extension "protoverse.project.org"
              :exclude "draft"
              :publishing-directory ,(expand-file-name "~/code/protoverse/whitepaper/")
              :publishing-function org-org-publish-to-org
              :headline-levels 6
              :section-numbers t
              :auto-sitemap nil
              :preserve-breaks t
              :with-title t
              :with-toc t
              :with-smart-quotes t
              :with-drawers nil
              :with-email t
              )
            org-publish-project-alist)

;;  ____________________________________________________________________________
(provide 'mjj-publish)
;;; mjj-publish.el ends here
