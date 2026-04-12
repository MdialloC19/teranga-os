/*
 * ============================================================
 * TérangaOS — teranga-cli
 * Outil de gestion système pour TérangaOS
 * 
 * Usage :
 *   teranga version       Afficher la version
 *   teranga status        État du système
 *   teranga security      Vérification de sécurité
 *   teranga update        Mettre à jour le système
 *   teranga info          Informations système
 *   teranga help          Aide
 *
 * Licence : GPLv3
 * Auteur  : Moussa Diallo
 * ============================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>
#include <sys/sysinfo.h>
#include <time.h>
#include <errno.h>

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

/* --- Utilitaires --- */

/**
 * Exécuter une commande shell et récupérer la sortie
 * Retourne 0 si succès, -1 si erreur
 */
int run_command(const char *cmd, char *output, size_t output_size)
{
    FILE *fp = popen(cmd, "r");
    if (fp == NULL)
        return -1;
    
    output[0] = '\0';
    char line[256];
    while (fgets(line, sizeof(line), fp) != NULL) {
        if (strlen(output) + strlen(line) < output_size - 1)
            strcat(output, line);
    }
    
    /* Supprimer le retour à la ligne final */
    size_t len = strlen(output);
    if (len > 0 && output[len - 1] == '\n')
        output[len - 1] = '\0';
    
    return pclose(fp);
}

/**
 * Vérifier si un service systemd est actif
 */
int is_service_active(const char *service)
{
    char cmd[256];
    char output[64];
    
    snprintf(cmd, sizeof(cmd), "systemctl is-active %s 2>/dev/null", service);
    run_command(cmd, output, sizeof(output));
    
    return (strcmp(output, "active") == 0);
}

/**
 * Vérifier si un binaire est installé
 */
int is_installed(const char *binary)
{
    char cmd[256];
    char output[512];
    
    snprintf(cmd, sizeof(cmd), "which %s 2>/dev/null", binary);
    return (run_command(cmd, output, sizeof(output)) == 0 && strlen(output) > 0);
}

/**
 * Lire un fichier et récupérer une valeur
 */
int read_file_value(const char *filepath, char *output, size_t output_size)
{
    FILE *fp = fopen(filepath, "r");
    if (fp == NULL)
        return -1;
    
    if (fgets(output, output_size, fp) != NULL) {
        size_t len = strlen(output);
        if (len > 0 && output[len - 1] == '\n')
            output[len - 1] = '\0';
    }
    
    fclose(fp);
    return 0;
}

/* ============================================================
 * COMMANDES
 * ============================================================ */

void print_banner(void)
{
    printf("\n");
    printf(COLOR_GREEN COLOR_BOLD);
    printf("  ╔═══════════════════════════════════════╗\n");
    printf("  ║         🇸🇳  TérangaOS  🇸🇳              ║\n");
    printf("  ║   Distribution Linux souveraine       ║\n");
    printf("  ╚═══════════════════════════════════════╝\n");
    printf(COLOR_RESET);
    printf("\n");
}

/* --- teranga version --- */
void cmd_version(void)
{
    printf("TérangaOS %s (%s)\n", TERANGA_VERSION, TERANGA_CODENAME);
}

/* --- teranga info --- */
void cmd_info(void)
{
    struct utsname uts;
    struct sysinfo si;
    char output[512];
    
    print_banner();
    
    /* Version TérangaOS */
    printf("  %-20s %s (%s)\n", "TérangaOS :", TERANGA_VERSION, TERANGA_CODENAME);
    
    /* Kernel */
    if (uname(&uts) == 0) {
        printf("  %-20s %s\n", "Kernel :", uts.release);
        printf("  %-20s %s\n", "Architecture :", uts.machine);
        printf("  %-20s %s\n", "Hostname :", uts.nodename);
    }
    
    /* Mémoire RAM */
    if (sysinfo(&si) == 0) {
        unsigned long total_mb = si.totalram / (1024 * 1024);
        unsigned long free_mb = si.freeram / (1024 * 1024);
        unsigned long used_mb = total_mb - free_mb;
        printf("  %-20s %lu Mo / %lu Mo (%lu%%)\n", "RAM :",
               used_mb, total_mb, (used_mb * 100) / total_mb);
        
        /* Uptime */
        long hours = si.uptime / 3600;
        long mins = (si.uptime % 3600) / 60;
        printf("  %-20s %ldh %ldm\n", "Uptime :", hours, mins);
    }
    
    /* Espace disque */
    struct statvfs vfs;
    if (statvfs("/", &vfs) == 0) {
        unsigned long total_gb = (vfs.f_blocks * vfs.f_frsize) / (1024 * 1024 * 1024);
        unsigned long free_gb = (vfs.f_bavail * vfs.f_frsize) / (1024 * 1024 * 1024);
        unsigned long used_gb = total_gb - free_gb;
        printf("  %-20s %lu Go / %lu Go (%lu%%)\n", "Disque :",
               used_gb, total_gb,
               total_gb > 0 ? (used_gb * 100) / total_gb : 0);
    }
    
    /* CPU */
    if (run_command("grep -c ^processor /proc/cpuinfo 2>/dev/null", output, sizeof(output)) == 0)
        printf("  %-20s %s cœurs\n", "CPU :", output);
    
    /* IP */
    if (run_command("hostname -I 2>/dev/null | awk '{print $1}'", output, sizeof(output)) == 0)
        printf("  %-20s %s\n", "IP :", output);
    
    /* Date */
    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    char date_str[64];
    strftime(date_str, sizeof(date_str), "%d/%m/%Y %H:%M", t);
    printf("  %-20s %s\n", "Date :", date_str);
    
    printf("\n  %-20s %s\n", "Site web :", TERANGA_WEBSITE);
    printf("  %-20s %s\n", "Code source :", TERANGA_REPO);
    printf("\n");
}

/* --- teranga status --- */
void cmd_status(void)
{
    printf("\n");
    printf(COLOR_BOLD "  État du système TérangaOS\n" COLOR_RESET);
    printf("  ────────────────────────\n\n");
    
    /* Services critiques */
    printf(COLOR_BOLD "  Services :\n" COLOR_RESET);
    
    const char *services[][2] = {
        {"ufw",        "Firewall (UFW)"},
        {"apparmor",   "Contrôle d'accès (AppArmor)"},
        {"clamav-daemon", "Antivirus (ClamAV)"},
        {"fail2ban",   "Anti-intrusion (Fail2ban)"},
        {"sshd",       "Accès distant (SSH)"},
        {"NetworkManager", "Réseau"},
        {NULL, NULL}
    };
    
    for (int i = 0; services[i][0] != NULL; i++) {
        if (is_service_active(services[i][0]))
            printf("%s  %s\n", OK_ICON, services[i][1]);
        else
            printf("%s  %s (inactif)\n", WARN_ICON, services[i][1]);
    }
    
    /* Applications installées */
    printf("\n" COLOR_BOLD "  Applications :\n" COLOR_RESET);
    
    const char *apps[][2] = {
        {"libreoffice",   "LibreOffice (bureautique)"},
        {"firefox-esr",   "Firefox (navigateur)"},
        {"thunderbird",   "Thunderbird (email)"},
        {"vlc",           "VLC (multimédia)"},
        {"keepassxc",     "KeePassXC (mots de passe)"},
        {NULL, NULL}
    };
    
    for (int i = 0; apps[i][0] != NULL; i++) {
        if (is_installed(apps[i][0]))
            printf("%s  %s\n", OK_ICON, apps[i][1]);
        else
            printf("%s  %s (non installé)\n", FAIL_ICON, apps[i][1]);
    }
    
    /* Mises à jour */
    printf("\n" COLOR_BOLD "  Mises à jour :\n" COLOR_RESET);
    char output[512];
    if (run_command("apt list --upgradable 2>/dev/null | grep -c upgradable", output, sizeof(output)) == 0) {
        int count = atoi(output);
        if (count > 0)
            printf("%s  %d mise(s) à jour disponible(s)\n", WARN_ICON, count);
        else
            printf("%s  Système à jour\n", OK_ICON);
    }
    
    printf("\n");
}

/* --- teranga security --- */
void cmd_security(void)
{
    int score = 0;
    int total = 0;
    
    printf("\n");
    printf(COLOR_BOLD "  🔒 Vérification de sécurité TérangaOS\n" COLOR_RESET);
    printf("  ─────────────────────────────────────\n\n");
    
    /* 1. Firewall */
    total++;
    char output[512];
    if (run_command("ufw status 2>/dev/null | head -1", output, sizeof(output)) == 0 &&
        strstr(output, "active") != NULL) {
        printf("%s  Firewall UFW actif\n", OK_ICON);
        score++;
    } else {
        printf("%s  Firewall UFW INACTIF — exécutez : sudo ufw enable\n", FAIL_ICON);
    }
    
    /* 2. AppArmor */
    total++;
    if (run_command("aa-status --enabled 2>/dev/null", output, sizeof(output)) == 0) {
        printf("%s  AppArmor activé\n", OK_ICON);
        score++;
    } else {
        printf("%s  AppArmor DÉSACTIVÉ\n", FAIL_ICON);
    }
    
    /* 3. Chiffrement disque */
    total++;
    if (run_command("lsblk -o TYPE 2>/dev/null | grep -c crypt", output, sizeof(output)) == 0 &&
        atoi(output) > 0) {
        printf("%s  Chiffrement disque (LUKS) actif\n", OK_ICON);
        score++;
    } else {
        printf("%s  Disque NON chiffré — risque si vol physique\n", WARN_ICON);
    }
    
    /* 4. Mises à jour automatiques */
    total++;
    if (access("/etc/apt/apt.conf.d/50unattended-upgrades", F_OK) == 0) {
        printf("%s  Mises à jour automatiques configurées\n", OK_ICON);
        score++;
    } else {
        printf("%s  Mises à jour automatiques NON configurées\n", FAIL_ICON);
    }
    
    /* 5. SSH : pas de login root */
    total++;
    if (run_command("grep -c '^PermitRootLogin no' /etc/ssh/sshd_config 2>/dev/null",
                    output, sizeof(output)) == 0 && atoi(output) > 0) {
        printf("%s  SSH : login root désactivé\n", OK_ICON);
        score++;
    } else {
        printf("%s  SSH : login root AUTORISÉ — risque de sécurité\n", WARN_ICON);
    }
    
    /* 6. Fail2ban */
    total++;
    if (is_service_active("fail2ban")) {
        printf("%s  Fail2ban actif (anti brute-force)\n", OK_ICON);
        score++;
    } else {
        printf("%s  Fail2ban INACTIF\n", WARN_ICON);
    }
    
    /* 7. Kernel hardening */
    total++;
    if (access("/etc/sysctl.d/99-terangaos.conf", F_OK) == 0 ||
        access("/etc/sysctl.d/99-terangaos-security.conf", F_OK) == 0) {
        printf("%s  Paramètres kernel sécurisés\n", OK_ICON);
        score++;
    } else {
        printf("%s  Pas de durcissement kernel TérangaOS\n", FAIL_ICON);
    }
    
    /* 8. ClamAV */
    total++;
    if (is_service_active("clamav-daemon")) {
        printf("%s  Antivirus ClamAV actif\n", OK_ICON);
        score++;
    } else {
        printf("%s  Antivirus ClamAV INACTIF\n", WARN_ICON);
    }
    
    /* Score final */
    printf("\n  ─────────────────────────────────────\n");
    
    int percent = (score * 100) / total;
    const char *color;
    const char *verdict;
    
    if (percent >= 80) {
        color = COLOR_GREEN;
        verdict = "EXCELLENT";
    } else if (percent >= 60) {
        color = COLOR_YELLOW;
        verdict = "CORRECT — améliorations possibles";
    } else {
        color = COLOR_RED;
        verdict = "INSUFFISANT — action requise";
    }
    
    printf("\n  Score : %s%s%d/%d (%d%%) — %s%s\n\n",
           COLOR_BOLD, color, score, total, percent, verdict, COLOR_RESET);
}

/* --- teranga update --- */
void cmd_update(void)
{
    if (geteuid() != 0) {
        printf(COLOR_RED "  Erreur : cette commande nécessite les droits root\n" COLOR_RESET);
        printf("  Usage : sudo teranga update\n\n");
        return;
    }
    
    printf("\n");
    printf(COLOR_BOLD "  🔄 Mise à jour TérangaOS\n" COLOR_RESET);
    printf("  ───────────────────────\n\n");
    
    printf("  [1/3] Mise à jour des dépôts...\n");
    system("apt update -qq");
    
    printf("  [2/3] Installation des mises à jour...\n");
    system("apt upgrade -y -qq");
    
    printf("  [3/3] Nettoyage...\n");
    system("apt autoremove -y -qq");
    
    printf("\n%s  Système mis à jour avec succès !\n\n", OK_ICON);
}

/* --- teranga help --- */
void cmd_help(void)
{
    print_banner();
    
    printf("  Usage : teranga <commande>\n\n");
    printf("  Commandes disponibles :\n\n");
    printf("    " COLOR_GREEN "version" COLOR_RESET "     Afficher la version de TérangaOS\n");
    printf("    " COLOR_GREEN "info" COLOR_RESET "        Informations système détaillées\n");
    printf("    " COLOR_GREEN "status" COLOR_RESET "      État des services et applications\n");
    printf("    " COLOR_GREEN "security" COLOR_RESET "    Vérification de sécurité\n");
    printf("    " COLOR_GREEN "update" COLOR_RESET "      Mettre à jour le système (sudo)\n");
    printf("    " COLOR_GREEN "help" COLOR_RESET "        Afficher cette aide\n");
    printf("\n");
    printf("  Exemples :\n");
    printf("    teranga info          # Voir les infos système\n");
    printf("    teranga security      # Audit de sécurité\n");
    printf("    sudo teranga update   # Mettre à jour\n");
    printf("\n");
    printf("  " COLOR_BLUE "%s" COLOR_RESET "\n\n", TERANGA_REPO);
}

/* ============================================================
 * MAIN
 * ============================================================ */
int main(int argc, char *argv[])
{
    if (argc < 2) {
        cmd_help();
        return 0;
    }
    
    const char *command = argv[1];
    
    if (strcmp(command, "version") == 0 || strcmp(command, "--version") == 0 || strcmp(command, "-v") == 0)
        cmd_version();
    else if (strcmp(command, "info") == 0)
        cmd_info();
    else if (strcmp(command, "status") == 0)
        cmd_status();
    else if (strcmp(command, "security") == 0)
        cmd_security();
    else if (strcmp(command, "update") == 0)
        cmd_update();
    else if (strcmp(command, "help") == 0 || strcmp(command, "--help") == 0 || strcmp(command, "-h") == 0)
        cmd_help();
    else {
        printf(COLOR_RED "  Commande inconnue : %s\n" COLOR_RESET, command);
        printf("  Tapez 'teranga help' pour voir les commandes disponibles.\n\n");
        return 1;
    }
    
    return 0;
}
