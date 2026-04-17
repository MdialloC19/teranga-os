/*
 * ============================================================
 * TérangaOS — teranga-cli
 * Fichier d'en-tête principal
 *
 * Licence : GPLv3
 * Auteur  : Moussa Diallo
 * ============================================================
 */

#ifndef CLI_H
#define CLI_H

/*
 * Activer les extensions POSIX (popen, pclose, etc.)
 * Doit être défini AVANT tout #include
 */
#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>
#include <time.h>
#include <errno.h>

/* sys/sysinfo.h est Linux uniquement */
#ifdef __linux__
#include <sys/sysinfo.h>
#endif

/* --- Constantes --- */
#define TERANGA_VERSION   "0.1.0-alpha"
#define TERANGA_CODENAME  "Dakar"
#define TERANGA_WEBSITE   "https://teranga-os.org"
#define TERANGA_REPO      "https://github.com/MdialloC19/teranga-os"

/* --- Couleurs terminal --- */
#define COLOR_GREEN   "\033[0;32m"
#define COLOR_YELLOW  "\033[1;33m"
#define COLOR_RED     "\033[0;31m"
#define COLOR_BLUE    "\033[0;34m"
#define COLOR_BOLD    "\033[1m"
#define COLOR_RESET   "\033[0m"

#define OK_ICON    COLOR_GREEN  "  ✓" COLOR_RESET
#define WARN_ICON  COLOR_YELLOW "  ⚠" COLOR_RESET
#define FAIL_ICON  COLOR_RED    "  ✗" COLOR_RESET

/* --- Prototypes --- */
void cmd_version(void);
void cmd_status(void);
void cmd_security(void);
void cmd_update(void);
void cmd_info(void);
void cmd_help(void);
void print_banner(void);

/* --- Prototypes utilitaires --- */
int run_command(const char *cmd, char *output, size_t output_size);
int is_service_active(const char *service);
int is_installed(const char *binary);
int read_file_value(const char *filepath, char *output, size_t output_size);

#endif /* CLI_H */
