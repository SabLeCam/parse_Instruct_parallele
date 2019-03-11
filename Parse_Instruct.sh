#!/bin/bash


out_path=$1 #emplacement du fichier output
out_dir=$2 #nom du fichier de sortie


###après utilisation du script Instruct-auto: un fichier par run
###recupérer DIC pour chaque run
###mettre en forme données pour clumpak (matrices q value 1 fichier par run)


###on crée un fichier pour info DIC et log Likelihood
echo "K,Mean,Variance,DIC"  1> $out_path/temp.csv


###on crée un dossier pour patrices qvalue
mkdir $out_dir


for f in $out_path/results_run*; do
ID=$(basename $f)
echo $ID

   #extraction des qvalues
awk '/Label/{flag=1;next}/index/{flag=0}flag' $f | cut -f 5- >  $out_dir/'clumpak'$ID
   #extraction valeur DIC et Ln
awk -F " " '{
		if ($2=="current")
        {K=$5};
		if ($3=="Likelihood:")
         {
		 {for (i=1; i<=12; i++) {getline;
		  {if (i==1) {Mean=$4}}
		   {if (i==2) {Variance=$4}}
            {if (i==4) {DIC=$9}}
            }};
       print K "," Mean "," Variance "," DIC;
       }}'  $f 1>> temp.csv
done

   #enlever les points à la fin des lignes (DIC)
sed -e 's/\.$//' temp.csv > result_Ln-DIC.csv
rm temp.csv
#zip -r '$out_dir'.zip $outdir
