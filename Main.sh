#!/bin/bash

display_ascii_art() {
    figlet -f standard "MultiScan"
    echo
    echo "Author: crishbit"
    echo
    echo "kontak: @crishbit"
    echo
    echo
}


handle_interruption() {
    echo
    read -p "Process interrupted. Do you want to continue to the next tool? (Y/n): " choice
    echo
    if [[ "$choice" == "n" || "$choice" == "N" ]]; then
        echo "Exiting..."
        exit 0
    fi
}


scan_website() {
    display_ascii_art

    read -p "Enter the website domain (without HTTP/HTTPS): " website

    
    echo "Choose the website protocol:"
    echo "1. HTTP"
    echo "2. HTTPS"
    read -p "Enter your choice: " protocol_choice
    echo

    if [ $protocol_choice -eq 1 ]; then
        protocol="http://"
    elif [ $protocol_choice -eq 2 ]; then
        protocol="https://"
    else
        echo "Invalid choice. Exiting..."
        return
    fi

    trap handle_interruption INT

    
    echo "Scanning website: $website"
    echo "Protocol: $protocol"
    echo

    
    report_file="reports/pentest-report.html"
    echo "<html><head><title>Pentest Report</title></head><body>" > "$report_file"

    
    echo "Running SQLMap..."
    sqlmap -u "$protocol$website" --crawl 5 --random-agent --level=3 --risk=1 --time-sec=40 --threads=6  --tamper=varnish.py,space2comment.py,between.py,randomcase --no-cast --timeout=170 --skip=Host,User-Agent --current-user --is-dba --privileges  --dbs --batch | tee -a "$report_file"
    handle_interruption

    
    echo "Running Commix..."
    python3 commix/commix.py -u "$protocol$website" --crawl 3 --all --batch | tee -a "$report_file"
    handle_interruption

    
    echo "Running Nikto..."
    nikto -h "$protocol$website" -C all -Tuning x -Plugins @@DEFAULT | tee -a "$report_file"
    handle_interruption

    
    echo "Running Dirb..."
    dirb "$protocol$website" | tee -a "$report_file"
    handle_interruption

    
    echo "Running Wfuzz..."
    wfuzz -w ~/MultiScan/wordlist/All_attack.txt  "$protocol$website/FUZZ" | tee -a "$report_file"
    handle_interruption

    
    echo "Running SSLScan..."
    sslscan "$website" | tee -a "$report_file"
    handle_interruption

    
    echo "Running Wpscan..."
    wpscan --url "$website" --batch | tee -a "$report_file"
    handle_interruption

    
    echo "Running Sslyze..."
    sslyze --regular "$website" | tee -a "$report_file"
    handle_interruption

    
    echo "Running Skipfish..."
    skipfish "$protocol$website" | tee -a "$report_file"
    handle_interruption

    
    echo "Running Wapiti..."
    wapiti -u "$protocol$website"  | tee -a "$report_file"
    handle_interruption

    echo "Running SubFinder..."
    subfinder -d "$website"  | tee -a "$report_file"
    handle_interruption

    echo "Running httpx ..."
    httpx -d "$website"  | tee -a "$report_file"
    handle_interruption

    echo "Running XSStrike..."
    python3 XSStrike/xsstrike.py -u "$protocol$website" --crawl -l 3 -t 10 -e base64 | tee -a "$report_file"
    handle_interruption

    
    echo "Running Nmap..."
    nmap -PN -sT --script vuln "$website" | tee -a "$report_file"
    handle_interruption

    
    echo "</body></html>" >> "$report_file"

    echo
    echo "Scan completed. The consolidated HTML report is saved in: $report_file"
    echo
    echo "Please don't forget to help us improve, terimakasih  "
}


scan_website
