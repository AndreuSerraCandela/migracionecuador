table 70000 "Plantilla Queen Mat. Comerc."
{
    fields
    {
        field(1; "ID MAT QUEEN"; Code[30])
        {
            Description = 'Código de material.';
        }
        field(2; "TIPO MATERIAL"; Code[1])
        {
            Description = 'M:Manuscrito (no aplica)L: Libro Físico D:Digital K:Material Marketing C:Combo Primero se aplica si es combo (pack, kit)';
        }
        field(3; ISBN; Code[30])
        {
            Description = 'En materiales Marketing NO aplica.';
        }
        field(4; "Id manuscrito"; Code[10])
        {
            Description = 'Codigo que agrupa isbn de la misma obra';
        }
        field(5; "Codigo producto de grupo"; Code[10])
        {
            Description = 'Codigo que identifica un producto a nivel de grupo';
        }
        field(6; "Codigo manuscrito grupo"; Code[10])
        {
            Description = 'Codigo que identifica un manuscrito a nivel de grupo';
        }
        field(7; "Sociedad propietaria"; Code[10])
        {
            Description = 'Sociedad propietaria de los derechos o informa PRH';
        }
        field(8; "Fecha prevista Publicacion"; Code[8])
        {
            Description = '(NO obligatoriopara TIPO MATERIAL: K  )';
        }
        field(9; "Título definitivo"; Code[120]) { }
        field(10; "Subtítulo"; Text[80]) { }
        field(11; "NIF Autor Comercial"; Code[30])
        {
            Description = 'Debe venir de tabla GL024';
        }
        field(12; Sello; Text[80])
        {
            Description = 'Debe venir de tabla GL003, Recibimos lookup';
        }
        field(13; Linea; Text[80])
        {
            Description = 'Debe venir de tabla GL004, Recibimos lookup';
        }
        field(14; "Colección"; Text[30])
        {
            Description = 'Texto del nivel 7 de la jerarquía de productos. Se agrupa en PRHGE';
        }
        field(15; "Nº páginas del artículo"; Integer) { }
        field(16; Ancho; Integer)
        {
            Description = '13 (3 decimales)';
        }
        field(17; Alto; Integer)
        {
            Description = '13 (3 decimales)';
        }
        field(18; Grueso; Integer)
        {
            Description = '13 (3 decimales)';
        }
        field(19; Peso; Integer)
        {
            Description = '13 (3 decimales) En KG';
        }
        field(20; "Tipo Encuadernación"; Code[10])
        {
            Description = 'Debe venir de tabla GL23';
        }
        field(21; "Precio con IVA"; Decimal)
        {
            Description = '15 (3 decimales) Precio con impuestos incluidos.';
        }
        field(22; Moneda; Code[10]) { }
        field(23; "Valido desde"; Code[20])
        {
            Description = 'Fecha de precio vigente. En el formato AAAAMMDD';
        }
        field(24; "Valido hasta"; Code[20])
        {
            Description = 'No Aplica';
        }
        field(25; "Clasificación Fiscal"; Code[10])
        {
            Description = 'Porcentaje del impuesto.';
        }
        field(26; "Idioma Original"; Code[10])
        {
            Description = 'Código ISO Idioma';
        }
        field(27; "Idioma de publicación"; Code[10])
        {
            Description = 'Código ISO Idioma';
        }
        field(29; "Estado Catálogo"; Code[10])
        {
            Description = 'Estado';
        }
        field(30; "Nº Òltima Edición"; Code[30]) { }
        field(31; "Editor Original"; Code[10])
        {
            Description = 'No aplica';
        }
        field(32; "Editor de Gestión"; Text[30])
        {
            Description = 'GL022, Nombre Editor gestión e mandar los usuarios';
        }
        field(33; "Título Original"; Text[110]) { }
        field(34; "Idioma de la traducción"; Code[10])
        {
            Description = 'No aplica';
        }
        field(35; Personaje; Code[10])
        {
            Description = 'No aplica';
        }
        field(36; "Nº de artículo en Colección"; Code[20]) { }
        field(37; "No. Art. en Biblioteca Autor"; Code[10])
        {
            Description = 'No aplica';
        }
        field(38; "Fecha puesta en venta"; Code[8])
        {
            Description = 'Fecha primera salida almacen';
        }
        field(39; "Articulo Embalado"; Code[10])
        {
            Description = 'No aplica. Mandar vacio.';
        }
        field(40; Componente; Code[1])
        {
            Description = '''X'' Indicador de componente de combo';
        }
        field(41; Compuesto; Code[1])
        {
            Description = '''X'' Indicador de combo';
        }
        field(42; "Fecha última edición"; Code[8])
        {
            Description = 'La fecha de última entrada en almacén';
        }
        field(43; "Fecha primera fact."; Code[8])
        {
            Description = 'Fecha primera salida de almacén.';
        }
        field(44; "Fecha primera venta"; Code[10])
        {
            Description = 'Fecha primera salida de almacén';
        }
        field(45; "Categoría Editorial"; Code[10])
        {
            Description = 'No aplica.';
        }
        field(46; "Target Edad desde"; Code[20])
        {
            Description = 'Lectura recomendada para esta edad';
        }
        field(47; "Descripción breve"; Text[30])
        {
            Description = 'No aplica';
        }
        field(48; Sinopsis; Text[250])
        {
            Description = 'Texto Contraportada';
        }
        field(49; "Biografía"; Text[250])
        {
            Description = 'Biografía Autor';
        }
        field(50; "Depósito Legal"; Text[30]) { }
        field(51; "Fecha publicación"; Code[8])
        {
            Description = 'Poner la misma que fecha puesta en venta';
        }
        field(52; "TEMATICA WEB 1"; Text[30])
        {
            Description = 'Bolsillo';
        }
        field(53; "TEMATICA WEB 2"; Text[30])
        {
            Description = 'Romántica';
        }
        field(54; "TEMATICA WEB 3"; Text[30])
        {
            Description = 'Juvenil';
        }
        field(55; "TEMATICA WEB 4"; Text[30])
        {
            Description = 'Infantil';
        }
        field(56; "TEMATICA WEB 5"; Text[30])
        {
            Description = 'Ebook';
        }
        field(57; "TEMATICA WEB 6"; Text[30])
        {
            Description = 'App';
        }
        field(58; "FECHA PUBL 1º"; Code[10])
        {
            Description = 'Lo mismo que en fecha primera fact.';
        }
        field(59; "ISBN LIBRO FISICO"; Text[30])
        {
            Description = 'S (Obligatorio para digital), En libros digitales, informar el ISBN del libro físico, convertido a digital';
        }
        field(60; INEDITO; Text[30])
        {
            Description = 'Inédito Digital. No aplica. Vacio.';
        }
        field(61; "Classificación comercial"; Text[30])
        {
            Description = 'AR.';
        }
        field(62; "Tipo de producción"; Text[30])
        {
            Description = 'AR.';
        }
        field(63; "Posición Arancelaria"; Text[30])
        {
            Description = 'AR.';
        }
        field(64; "País Ult. Impresión"; Text[30])
        {
            Description = 'AR.';
        }
        field(65; "% dederchos de autor"; Code[20])
        {
            Description = 'AR.';
        }
        field(66; "CAtegoria editor"; Text[30])
        {
            Description = 'AR.';
        }
        field(67; "Target Edad hasta"; Code[20]) { }
    }

    keys
    {
        key(Key1; "ID MAT QUEEN")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}
