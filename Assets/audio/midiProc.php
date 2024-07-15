<?php

$songHex = bin2hex(file_get_contents("Alouette.mid"));

// Use a series of sequencial loops
// Keep everything simple
// Split hex into chars

$midi = array();
$target = array();
$final = array();
$notes = ""; 
$y = 0;
$z = 0;
$offToggle = 0;
/*
$midi[1] = array();
$midi[2] = array();
$midi[3] = array();
$midi[4] = array();
$midi[5] = array();
*/
for($x = 0; $x < strlen($songHex); $x = $x + 2)
    {
    $char = $songHex[$x] . $songHex[$x+1];
    $nextChar = $songHex[$x+2] . $songHex[$x+3];  
    $thirdChar = $songHex[$x+4] . $songHex[$x+5];
    $lastChar = $songHex[$x+6] . $songHex[$x+7];

    if($char == '4d')
    {
      if($nextChar == '54') 
      {
        if($thirdChar == '68')
           if($lastChar == '64')
            {
            $y = "header";
            }
        if($thirdChar == '72') 
            {
             if($y == "parms")$y = "trk";
		else
		$y = "parms";
            }
        $midi[$y] = array();
      }
    }

    array_push($midi[$y],$char);
    }

//for($x = 0; $x < count($midi); $x++)
//   echo "$x ";

$trkLen = count($midi['trk']);

$skip = 17;
$endSkip = $skip + 63;
/*
for($x = $skip; $x < $endSkip; $x++)
  {
  echo $midi['trk'][$x]; 
  if($x % 8 == 0)echo "\n";
  }

echo "\n-------------------\n";
*/
for($x = $endSkip; $x < $trkLen - 4; $x++)
  {

  if($midi['trk'][$x] == "90")$notes .= " ";
  if($midi['trk'][$x-1] == "90")$notes .= " ";
  if($midi['trk'][$x+1] == "90") 
   // if($midi['trk'][$x+3] = "00") 
                $notes .= "\n";

  if($midi['trk'][$x] == "80")$notes .= " ";
  if($midi['trk'][$x-1] == "80")$notes .= " ";

  if($midi['trk'][$x+1] == "80") 
     if($midi['trk'][$x+3] = "00")
       {
          $offToggle = 1;
          $notes .= "\n";
       }
       else $offToggle = 0;
       
  if($midi['trk'][$x] == "00") if($offToggle == 1)
       {
         $notes .= " ";
         $offToggle = 0;
       }


  $notes .= $midi['trk'][$x];
  // echo " ";
//  if($midi['trk'][$x] = "80";
//  if(($x % 5) == 4)echo "\n";
  }
//$notes .= "\n";

$notesArray = explode("\n",$notes);
array_shift($notesArray);

foreach($notesArray as $id => $note)
   { 
   if($note[0] == " ")$note = substr($note,1);
   if($note[8] != " ")$note = substr($note,0,8) . ' ' . substr($note,8); 
   if($note[11] != " ")$note = substr($note,0,11) . ' ' . substr($note,11);

//   $target[$id] = $note;
   $target[$id] = explode(" ",$note);
   }


echo json_encode($target);
//   print_r($target);
//   echo $note . "\n";

// print_r($notesArray);

//echo $notes;
// print_r($midi['trk']);

?>
