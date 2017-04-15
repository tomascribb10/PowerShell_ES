#Definición de variables
[DateTime]$fecha = get-date 
$EUR = "1"
$USD = "1"
$filtro =([Uri]::EscapeDataString(($fecha | Get-Date -Format d)))

#Definición de URI Uniform Resource Identifier
$URI = [Uri]"http://www.bna.com.ar/Cotizador/HistoricoPrincipales?id=billetes&fecha={0}&filtroEuro={1}&filtroDolar={2}" -f $filtro, $EUR, $USD 

#Llamada a Invoke-WebRequest
$ResultWeb = Invoke-WebRequest -Uri:$URI 

#Parseo de resultado
$datos = ( $ResultWeb.ParsedHtml.getElementsByTagName("table") | Select-Object -First 3).rows
$tabla = @()
forEach($dato in $datos){
 if($dato.tagName -eq "tr"){
 $filas = @()
 $celdas = $dato.children
 forEach($celda in $celdas){
 if($celda.tagName -imatch "t[dh]"){
 $filas += $celda.innerText
 }
 }
 $tabla += $filas -join "-"
 }
}

$tabla
