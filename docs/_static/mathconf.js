// A $( document ).ready() block.
$( document ).ready(function() {
MathJax.Hub.Config({
  TeX: {
    Macros: {
        // All bold letters
        AA: '{\\mathbb{A}}',
        BB: '{\\mathbb{B}}',
        // Complex space symbol
        CC: '{\\mathbb{C}}',
        // A dictionary
        DD: '{\\mathbb{D}}',
        // Expectation operator
        EE: '{\\mathbb{E}}',
        // A field
        FF: '{\\mathbb{F}}',
        // A group
        GG: '{\\mathbb{G}}',
        // A Hilbert space
        HH: '{\\mathbb{H}}',
        // Irrational numbers
        II: '{\\mathbb{I}}',
        JJ: '{\\mathbb{J}}',
        // Real or complex space symbol
        KK: '{\\mathbb{K}}',
        // Natural numbers
        NN: '{\\mathbb{N}}',
        Nat: '{\\mathbb{N}}',
        // Probability set symbol
        PP: '{\\mathbb{P}}',
        // Rational numbers
        QQ: '{\\mathbb{Q}}',
        // Real line symbol
        RR: '{\\mathbb{R}}',
        RRMN: '{\\mathbb{R}^{M \\times N} }',
        // A linear operator
        TT: '{\\mathbb{T}}',
        // Another linear operator
        UU: '{\\mathbb{U}}',
        // A vector space
        VV: '{\\mathbb{V}}',
        // A subspace
        WW: '{\\mathbb{W}}',
        // An inner product space
        XX: '{\\mathbb{X}}',
        // Integers
        ZZ: '{\\mathbb{Z}}',
 
        // All mathcal shortcuts
        AAA: '{\\mathcal{A}}',
        BBB: '{\\mathcal{B}}',
        CCC: '{\\mathcal{C}}',
        DDD: '{\\mathcal{D}}',
        EEE: '{\\mathcal{E}}',
        FFF: '{\\mathcal{F}}',
        GGG: '{\\mathcal{G}}',
        HHH: '{\\mathcal{H}}',
        III: '{\\mathcal{I}}',
        JJJ: '{\\mathcal{J}}',
        KKK: '{\\mathcal{K}}',
        LLL: '{\\mathcal{L}}',
        MMM: '{\\mathcal{M}}',
        NNN: '{\\mathcal{N}}',
        OOO: '{\\mathcal{O}}',
        PPP: '{\\mathcal{P}}',
        QQQ: '{\\mathcal{Q}}',
        RRR: '{\\mathcal{R}}',
        SSS: '{\\mathcal{S}}',
        TTT: '{\\mathcal{T}}',
        UUU: '{\\mathcal{U}}',
        VVV: '{\\mathcal{V}}',
        WWW: '{\\mathcal{W}}',
        XXX: '{\\mathcal{X}}',
        YYY: '{\\mathcal{Y}}',
        ZZZ: '{\\mathcal{Z}}',

        Tau: '{\\mathcal{T}}',
        Chi: '{\\mathcal{X}}',
        Eta: '{\\mathcal{H}}',

        // Real part of a complex number
        Re: '\\operatorname{Re}',
        Im: '\\operatorname{Im}',


        // Null space
        NullSpace: '{\\mathcal{N}}',
        // Column space
        ColSpace: '{\\mathcal{C}}',
        // Row space
        RowSpace: '{\\mathcal{R}}',
        // Power set
        Power: '{\\mathop{\\mathcal{P}}}',
        LinTSpace:'{\\mathcal{L}}',

        // Range
        Range: '{\\mathrm{R}}',
        // image
        Image: '{\\mathrm{im}}',
        // Kernel
        Kernel: '{\\mathrm{ker}}',
        // Span
        Span: '{\\mathrm{span}}',
        // Nullity of an operator
        Nullity: '{\\mathrm{nullity}}',
        // Dimension of a vector space
        Dim: '{\\mathrm{dim}}',
        // Rank of a matrix
        Rank: '{\\mathrm{rank}}',
        // Trace of a matrix
        Trace: '{\\mathrm{tr}}',
        // Diagonal of a matrix
        Diag: '{\\mathrm{diag}}',
        // Signum function
        sgn: '{\\mathrm{sgn}}',
        // Support function
        supp: '{\\mathrm{supp}}',
        // Row support
        rowsupp: '{\\mathop{\\mathrm{rowsupp}}}',
        // Entry wise absolute value function
        abs: '{\\mathop{\\mathrm{abs}}}',
        // error function
        erf: '{\\mathop{\\mathrm{erf}}}',
        // complementary error function
        erfc: '{\\mathop{\\mathrm{erfc}}}',
        // Sub Gaussian function
        Sub: '{\\mathop{\\mathrm{Sub}}}',
        // Strictly sub Gaussian function
        SSub: '{\\mathop{\\mathrm{SSub}}}',
        // Variance function
        Var: '{\\mathop{\\mathrm{Var}}}',
        // Covariance matrix
        Cov: '{\\mathop{\\mathrm{Cov}}}',
        // Affine hull of a set
        AffineHull: '{\\mathop{\\mathrm{aff}}}',
        // Convex hull of a set
        ConvexHull: '{\\mathop{\\mathrm{conv}}}',


        // Set theory related stuff
        Card:['\\mathrm{card}\\,{#1}', 1],
        argmin:'\\mathrm{arg}\\,\\mathrm{min}',
        argmax:'\\mathrm{arg}\\,\\mathrm{max}',
        EmptySet:'\\varnothing',
        // Forall operator with some space
        Forall: '\\; \\forall \\;',


        // Probability distributions
        Gaussian: '{\\mathcal{N}}',


        // Sparse representations related stuff
        // Spark of a matrix
        spark: '{\\mathop{\\mathrm{spark}}}',
        // Exact Recovery Criterion
        ERC: '{\\mathop{\\mathrm{ERC}}}',
        // Maximum correlation
        Maxcor: '{\\mathop{\\mathrm{maxcor}}}',

        // pseudo-inverse
        dag: '\\dagger',
        // bracket operator
        Bracket: '\\left [ \\; \\right ]',
        bold: ['{\\bf #1}', 1],
        // OneVec
        OneVec: '\\mathcal{1}',
        ZeroVec: '0',
        OneMat: '\\mathbf{1}',
        bigO: ['\\mathop{}\\mathopen{}\\mathcal{O}\\mathopen{}\\left(#1\\right)', 1],
        smallO: ['\\scriptstyle\\mathcal{O}\\left(#1\\right)', 1]
    }
  }
});

var on_proof_caption_click  = function () {

    $header = $(this);
    //getting the next element
    $content = $header.next();
    //open up the content needed - toggle the slide- if visible, slide up, if not slidedown.
    $content.slideToggle(500, function () {
        //execute this after slideToggle is done
        //change text of header based on visibility of content div
        $header.text(function () {
            //change text based on condition
            return $content.is(":visible") ? "Proof" : "Click to see proof";
        });
    });

}
// Attach the on click handler to each proof element
$(".proof_caption").click(on_proof_caption_click);

MathJax.Hub.Queue(function () {
    // Collapse all proof elements in the beginning
    $(".proof_caption").each(on_proof_caption_click);
    // We want to disable the proofs initially
    $(".proof_caption").each(function(){
        $header = $(this);
        $header.text("Click to see proof");
    });
});

});

