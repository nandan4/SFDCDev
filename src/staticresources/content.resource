<apex:stylesheet value="{!URLFOR($Resource.bootstrap,'bootstrap.min.css')}"/>
    <apex:includeScript value="{!URLFOR($Resource.bootstrap,'jquery-1.10.2.min.js')}"/>
    <apex:includeScript value="{!URLFOR($Resource.bootstrap,'jquery.dataTables.min.js')}"/>
    <apex:includeScript value="{!URLFOR($Resource.bootstrap,'jquery-DT-pagination.js')}"/>
    
    <script type="text/javascript">
        /* Table initialisation */
        $(document).ready(function() {
            $('#example').dataTable( {
                "bSort": false,        // Disable sorting
                "iDisplayLength": 2,   // records per page
                "sDom": "t<'row'<'col-md-6'i><'col-md-6'p>>",
                "sPaginationType": "bootstrap"
            });
        });
    </script>
    
    <body>
        <div class="container">         
            <table class="table table-condensed table-bordered" id="example">
                <thead>
                    <tr>
                        <th>S.no</th>
                        <th>Column A</th>
                        <th>Column B</th>
                        <th>Column C</th>
                    </tr>
                </thead>
                <tbody>
                      <tr><td>1</td><td>A-col+1</td><td>B-col+1</td><td>C-col+1</td></tr>
                <tr><td>2</td><td>A-col+2</td><td>B-col+2</td><td>C-col+2</td></tr>
                <tr><td>3</td><td>A-col+3</td><td>B-col+3</td><td>C-col+3</td></tr>
                <tr><td>4</td><td>A-col+4</td><td>B-col+4</td><td>C-col+4</td></tr>
                <tr><td>5</td><td>A-col+5</td><td>B-col+5</td><td>C-col+5</td></tr>
               </tbody>
            </table>
        </div>
        </body>