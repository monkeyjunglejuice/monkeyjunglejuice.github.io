;;; mjj-publish.el --- MJJ publishing settings  -*- lexical-binding: t; -*-
;;; Commentary:
;; Adds project to `org-publish-project-alist'
;;; Code:

;;  ____________________________________________________________________________
;;; USE-PACKAGE
;; <https://github.com/jwiegley/use-package>

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package nil))

(eval-when-compile
  (require 'use-package))

;;  ____________________________________________________________________________
;;; ORG EXPORT AND PUBLISHING

;; <https://github.com/hniksic/emacs-htmlize>
(use-package htmlize
  :ensure t)

;; <https://orgmode.org/manual/HTML-Export.html>
(use-package ox-html
  :ensure nil)

;; <https://orgmode.org/manual/Publishing.html>
(use-package ox-publish
  :ensure nil)

;; Don't show day and hour
;; (setq org-html-metadata-timestamp-format "%Y-%m-%d")

;;  ____________________________________________________________________________
;;; PROJECT SPECIFIC

;; Set external 'css' or 'inline-css' for code snippets created by htmlize
;; CSS file can be generated with 'org-html-htmlize-generate-css'
(setq org-html-htmlize-output-type 'css)

;; Prevent littering the recently visited files with exported HTML
(require 'recentf)
(add-to-list 'recentf-exclude
             (expand-file-name "~/Documents/monkeyjunglejuice/"))

;;  ____________________________________________________________________________
;;; PAGE TEMPLATE

(defvar mjj-page-html-head nil "Lines to include in <head>...</head> specific to pages.")
(setq mjj-page-html-head
      (concat
       "<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'self'; script-src 'self' https://wa.skred.net/; connect-src https://wa.skred.net/; img-src 'self' https://*; media-src 'self' https://*;\">\n"
       "<meta name=\"google-site-verification\" content=\"WUje0h1DXIUXINogHFZva1zk3Lw1oSpgrqva9dubYq0\">\n"
       "<link rel=\"stylesheet\" href=\"/static/normalize.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/org.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/style.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/cormorant/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/gentium-basic/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/mononoki/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"icon\" type=\"image/svg+xml\" href=\"/static/monkeyjunglejuice.svg\">\n"
       "<link rel=\"apple-touch-icon\" href=\"/static/monkeyjunglejuice-icon180.png\">\n"
       "<script defer src=\"/static/header.js\"></script>\n"))

(defvar mjj-page-preamble nil "Header for pages.")
(setq mjj-page-preamble
      (concat
       "<nav id=\"nav-primary\">"
       "<a id=\"site-name\" href=\"/index.html\">MonkeyJungleJuice</a>"
       " "
       "<a id=\"github\" href=\"https://github.com/monkeyjunglejuice\">Github</a>"
       "</nav>"))

(defvar mjj-page-postamble nil "Footer for pages.")
(setq mjj-page-postamble
      (concat
       "<div class=\"footer\">Published by <span class=\"author\">%a</span> <span class=\"email\">%e</span></div>\n"
       "<script defer src=\"/static/footer.js\"></script>"))

;;  ____________________________________________________________________________
;;; BLOG TEMPLATE

(defvar mjj-blog-html-head nil "Lines to include in <head>...</head> specific to blog articles.")
(setq mjj-blog-html-head
      (concat
       "<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'self'; script-src 'self' https://wa.skred.net/; connect-src https://wa.skred.net/; img-src 'self' https://*; media-src 'self' https://*;\">\n"
       "<link rel=\"stylesheet\" href=\"/static/normalize.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/org.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/style.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/cormorant/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/gentium-basic/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"stylesheet\" href=\"/static/fonts/mononoki/fonts.css\" type=\"text/css\">\n"
       "<link rel=\"icon\" type=\"image/svg+xml\" href=\"/static/monkeyjunglejuice.svg\">\n"
       "<link rel=\"apple-touch-icon\" href=\"/static/monkeyjunglejuice-icon180.png\">\n"
       "<script defer src=\"/static/header.js\"></script>"))

(defvar mjj-blog-preamble nil "Header for blog articles.")
(setq mjj-blog-preamble
      (concat
       "<nav id=\"nav-primary\">"
       "<a id=\"site-name\" href=\"/index.html\">MonkeyJungleJuice</a>"
       " "
       "<a id=\"github\" href=\"https://github.com/monkeyjunglejuice\">Github</a>"
       "</nav>\n"
       "<div class=\"info\"><time itemprop=\"dateModified\" datetime=\"%C\">Last updated: %C</time></div>"))

(defvar mjj-blog-postamble nil "Footer for blog articles.")
(setq mjj-blog-postamble
      (concat
       "<div class=\"footer\">Published by <span class=\"author\">%a</span> <span class=\"email\">%e</span></div>\n"
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
(add-to-list 'org-publish-project-alist
             `("mjj"
               :components ("mjj-page" "mjj-blog")))

;;; PAGES project
(add-to-list 'org-publish-project-alist
             `("mjj-page"
               :base-directory "~/Documents/monkeyjunglejuice/"
               :base-extension "org"
               :exclude ".draft.org"
               :publishing-directory "~/Documents/monkeyjunglejuice/"
               :publishing-function org-html-publish-to-html
               :org-export-use-babel nil
               :headline-levels 6
               :section-numbers nil
               :auto-sitemap nil
               :preserve-breaks t
               :with-title t
               :with-smart-quotes t
               :with-drawers t
               :html-doctype "html5"
               :html-html5-fancy t
               :html-toplevel-hlevel 2
               :html-metadata-timestamp-format "%Y-%m-%d"
               :html-head ,mjj-page-html-head
               :html-head-include-scripts nil
               :html-head-include-default-style nil
               :html-preamble ,mjj-page-preamble
               :html-postamble ,mjj-page-postamble))

;;; BLOG ARTICLES project
(add-to-list 'org-publish-project-alist
             `("mjj-blog"
               :base-directory "~/Documents/monkeyjunglejuice/blog/"
               :base-extension "essay.org\\|howto.org\\|tutorial.org\\|walktrough.org\\|project.org"
               :exclude ".draft.org"
               :publishing-directory "~/Documents/monkeyjunglejuice/blog/"
               :publishing-function org-html-publish-to-html
               :org-export-use-babel nil
               :headline-levels 6
               :section-numbers nil
               :auto-sitemap nil
               :preserve-breaks t
               :with-title t
               :with-smart-quotes t
               :with-drawers t
               :html-doctype "html5"
               :html-html5-fancy t
               :html-toplevel-hlevel 2
               :html-metadata-timestamp-format "%Y-%m-%d"
               :html-head ,mjj-blog-html-head
               :html-head-include-scripts nil
               :html-head-include-default-style nil
               :html-preamble ,mjj-blog-preamble
               :html-postamble ,mjj-blog-postamble))

;;  ____________________________________________________________________________
(provide 'mjj-publish)
;;; mjj0publish.el ends here
