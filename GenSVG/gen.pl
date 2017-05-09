sub pre {
    print <<'END'
<?xml version='1.0' encoding='UTF-8' standalone='no'?>
<svg xmlns:svg='http://www.w3.org/2000/svg' xmlns='http://www.w3.org/2000/svg' version='1.2' baseProfile='tiny' x='0in' y='0in' width='2.71089in' height='2.11146in' viewBox='0 0 500 150' >

<g partID='2'><g xmlns="http://www.w3.org/2000/svg" id="silkscreen1">
 <path xmlns="http://www.w3.org/2000/svg" stroke-linecap="round" stroke="#330000" stroke-miterlimit="10" stroke-linejoin="round" id="outline_1_" fill="none" d="M183.208,0.818l4.308,4.304l0,32.276l7.182,7.172l0,92.526l-7.182,7.172l0,4.35c0.164,1.396,-0.839,2.66,-2.234,2.824c-0.191,0.021,-0.395,0.021,-0.592,0L3.65,151.442c-1.397,0.164,-2.663,-0.836,-2.827,-2.229c-0.023,-0.196,-0.023,-0.396,0,-0.596L0.823,3.642C0.66,2.245,1.661,0.98,3.058,0.818c0.196,-0.023,0.396,-0.023,0.592,0L183.208,0.818"/>
</g>
</g>


END
}

sub post {
    print <<'END';


</svg>
END

}

sub row {
    my ($x, $y, $keys) = @_;

    print "\n<g transform='translate($x, $y)'><!-- keyboard row -->\n";

    my $posx = $x + 5;

    foreach $k (split('', $keys)) {
        my $qchar = $k;
        my $o = ord($k);

        if ($o < 32) {
            $qchar = '^' . chr($o + 64);
        }
        if ($o > 127) {
            $qchar = 'ascii:' . 'x'; #$o;
        }

        # html chars
        $qchar = '&lt;' if $k eq '<';
        $qchar = '&gt;' if $k eq '>';
        $qchar = '&quot;' if $k eq '\'';

#        print STDERR "---$k = $o => '$qchar'\n";

        print "\n\n<!-- KEY '$qchar' -->\n";

        print "<g transform='translate($posx,0)' id='key_$qchar'>\n";
        $posx += 25;

        print "<path stroke-width='0.5' stroke='gray' fill='none' d='M-2 -2 h16 v12 h-16 v-12' />\n";
        print <<"KEY";
<text x="0" y="7" font-family="Verdana" font-size="10" fill='blue'>
  $qchar
</text>
KEY

        print <<'END';
<circle stroke="none" r="1.6" fill="black" cx="0" cy="0"/>
<circle stroke="none" r="1.6" fill="black" cx="0" cy="8"/>
<circle stroke="none" r="1.6" fill="black" cx="12" cy="0"/>
<circle stroke="none" r="1.6" fill="black" cx="12" cy="8"/>

<circle stroke="none" r="1.6" fill="orange" cx="22" cy="4"/>
<circle stroke="none" r="1.6" fill="orange" cx="14" cy="8"/>

<path d="M0 0
         h 30
         " fill='none' stroke='green' stroke-width='1'/>
<path d="M0 4
         h 30
         " fill='none' stroke='green' stroke-width='1'/>
<path d="M0 8
         h 12
         " fill='none' stroke='green' stroke-width='1'/>

END

        my $w = 16;

        $i = 0;
        $k = 1;
        while ($k <= 8) {
            if ($o & $k) {
                $l = 24-4*$i;
                print <<"END";
<circle stroke="none" r="1.6" fill="red" cx="$w" cy="8"/>
<circle stroke="none" r="1.6" fill="red" cx="$w" cy="$l"/>
END
                $w += 2;
            }
            $i++;
            $k *= 2;
        }

        print "</g>\n";
    }

    my $W = 357;
    print <<"END";
<g transform='translate(3,12)' id='key_5'>
<path d="M0 0
         h $W
         " fill='none' stroke='green' stroke-width='1'/>
<path d="M0 4
         h $W
         " fill='none' stroke='green' stroke-width='1'/>
<path d="M0 8
         h $W
         " fill='none' stroke='green' stroke-width='1'/>
<path d="M0 12
         h $W
         " fill='none' stroke='green' stroke-width='1'/>
</g>
END

    print "\n</g>\n";
}

pre();

# problem ~` key missing
$vspace = 30;
$row = 0;
$offset = 25;
row(0, $offset + $row++ * $vspace, "1234567890-=");      # ESC, ..., BS
row(2, $offset + $row++ * $vspace, "\tqwertyuiop[]\\");      # TAB,
row(4, $offset + $row++ * $vspace, "\100asdfghjkl;\'");    # CTRL, ..., ENTER
row(8, $offset + $row++ * $vspace, "\101zxcvbnm<>?\101");     # SHIFT, ..., SHIFT
row(50, $offset + $row++ * $vspace, "\102 \103");             # ALT, SPACE, ALT

post();
