table 70500 MCliente01
{

    fields
    {
        field(2; Tratamiento; Text[4])
        {
            Description = 'Tipo de tratamiento del cliente (Sr., Don, etc)';
        }
        field(3; "Nombre 1"; Text[100])
        {
            Description = 'Nombre del cliente';
        }
        field(4; "Nombre 2"; Text[100])
        {
            Description = 'Nombre Adicional';
        }
        field(5; "Concepto de busqueda"; Text[20])
        {
            Description = 'Denominación breve para ayudas de búsqueda.';
        }
        field(6; "Direccion calle"; Text[200])
        {
        }
        field(7; Poblacion; Text[60])
        {
        }
        field(8; "Codigo postal/Pobl"; Text[10])
        {
        }
        field(9; Pais; Text[20])
        {
            Description = 'Nuestra codificación.';
        }
        field(10; Region; Text[100])
        {
            Description = 'Nuestra codificación. Lookup en este documento.';
        }
        field(11; "Apartado de correos"; Text[10])
        {
        }
        field(12; "Cod.postal empresa"; Text[10])
        {
            Description = 'Código postal de la empresa (en caso de clientes import.) Código postal que se asigna directamente a una empresa.';
        }
        field(13; Idioma; Text[20])
        {
            Description = 'ES Por defecto';
        }
        field(14; Telefono; Text[30])
        {
        }
        field(15; Extension; Text[30])
        {
        }
        field(16; "Telefono Movil"; Text[30])
        {
        }
        field(17; Fax; Text[41])
        {
        }
        field(18; Extension2; Text[10])
        {
        }
        field(19; Email; Text[100])
        {
        }
        field(20; Comentarios; Text[50])
        {
        }
        field(21; Acreedor; Text[10])
        {
            Description = 'Indica una clave alfanumérica, que identifica unívocamente un el proveedor, o bien, acreedor en el Sistema R/3.';
        }
        field(22; "Clave de grupo"; Text[10])
        {
            Description = 'En caso de que el deudor o proveedor pertenezca a un grupo de empresas, se puede introducir aquí una clave de grupo. La clave de grupo puede asignarse libremente. Si se forma un matchcode mediante esta clave de grupo, podrá efectuar evaluaciones a nivel de grupo de empresas.';
        }
        field(23; "Nº ident.fis.1"; Text[30])
        {
            Description = 'Indica el número de identificación fiscal.';
        }
        field(24; "N.I.F. Comunitario"; Text[20])
        {
            Description = 'Número de identificación fiscal (N.I.F.CE) comunitario del deudor, acreedor o de su sociedad FI.';
        }
        field(25; "Persona fisica"; Text[20])
        {
            Description = 'Denomina una persona física.';
        }
        field(26; "Pais (Banco)"; Text[20])
        {
            Description = 'Identifica el país en el cual tiene su sede el banco.';
        }
        field(27; "Clave banco"; Text[15])
        {
            Description = 'En este campo se indica la clave bajo la cual se almacenan los datos bancarios en el país correspondiente.';
        }
        field(28; "Cuenta bancaria"; Text[18])
        {
            Description = 'Este campo contiene el número bajo el cual se lleva la cuenta en el banco.';
        }
        field(29; Titular; Text[30])
        {
            Description = 'Indicación adicional de nombre necesaria para la gestión automártica de pagos cuando el nombre del titular de la cuenta no coincide con el nombre del deudor o del acreedor';
        }
        field(30; "Clave de control"; Text[30])
        {
            Description = 'Este campo contiene una clave de verificación para la combinación del código bancario y el número de la cuenta bancaria.';
        }
        field(31; Iban; Text[34])
        {
            Description = 'Se trata del número de identificación unívoco para representar los datos bancarios siguiendo la normativa del ECBS (European Commitee for Banking Standards). Un IBAN contiene un máximo de 34 caracteres alfanuméricos que combina los siguientes elementos:';
        }
        field(32; "Clase Cliente"; Text[20])
        {
            Description = 'Indica la clasificación de clientes (por ejemplo, mayorista).Mandar nuestro tipo de cliente. Lookup en este documento.';
        }
        field(33; Ramo; Text[20])
        {
            Description = 'Clave de ramo industrial. Un ramo es una división por empresas según el centro de gravedad de su actividad económica. Se utiliza la clave de ramo para limitar las evaluaciones (p. ej., índice de datos maestros de acreedor). Se pueden utilizar como ramos,';
        }
        field(34; "Código ramo 1"; Text[10])
        {
            Description = 'Indica un código que identifica unívocamente el ramo (o los ramos) del cliente.';
        }
        field(35; "Cuenta asociada"; Text[10])
        {
            Description = 'Cuenta asociada en la contabilidad principal. La cuenta asociada en la contabilidad de mayor es aquella, en la que se actualizan valores (p.ej., de facturas, pagos, etc.) paralelamente a la cuenta de la contabilidad secundaria.';
        }
        field(36; "Clave clasif"; Text[10])
        {
            Description = 'Clave para clasificar por números de asignación. Clave que simboliza la regla de estructuración para el campo Asignación en la posición del documento.';
        }
        field(37; "Grupo Tesoreria"; Text[10])
        {
            Description = 'En la gestión de caja se asignan deudores y acreedores a través de una entrada de registro maestro a grupos de tesorería.';
        }
        field(38; "Condiciones de pago"; Text[10])
        {
            Description = 'Clave mediante la que se definen las condiciones de pago en forma de tipos de descuento y plazos de pago.';
        }
        field(39; "Gabar historial de pagos"; Text[10])
        {
            Description = 'Indicador que fija que se grabe el historial de pago del deudor. Se registran por mes natural los importes y número de los pagos y el promedio de días de demora. Las informaciones se graban separadamente en para pagos con descuento y pagos netos.Mandar vacio.';
        }
        field(40; "Vias de pago"; Text[10])
        {
            Description = 'Lista de las vías de pago que pueden utilizarse en los pagos automáticos con esta empresa colaboradora si no se ha indicado ninguna vía de pago en la partida a pagar.';
        }
        field(41; "Pago unico"; Text[10])
        {
            Description = 'Indicador: Pagar todas las partidas individualmente. A través de este campo se fija que se pague por separado cada partida abierta del interlocutor comercial. Esto quiere decir, que las par- tidas abiertas no se agruparán para el pago.';
        }
        field(42; "Extracto de cuenta"; Text[10])
        {
            Description = 'Identificación para extractos de cuenta periódicos. En el registro maestro puede definirse una identificación para que la cuenta sea tenida en consideración por el sistema al generar extractos periódicos. Definiendo varias identificaciones, será posible formar grupos de cuentas con intervalos diferentes para los extractos de cuenta. Las identificaciones pueden definirse libremente.1Extracto de cuenta semanal o tipo 12Extracto de cuenta mensual o tipo 2';
        }
        field(43; "Cta.en deudor"; Text[30])
        {
            Description = 'Visualiza el número de cuenta bajo el cual se registra la propia empresa en el deudor.';
        }
        field(44; "Respons.deudor"; Text[30])
        {
            Description = 'Nombre o sigla del responsable en la empresa del deudor.';
        }
        field(45; "Tel.responsable"; Text[30])
        {
            Description = 'Número de teléfono del responsable en interlocutor comercial';
        }
        field(46; "Telefax encarg."; Text[30])
        {
            Description = 'Telefax del encargado en el interlocutor comercial';
        }
        field(47; "Internet resp."; Text[30])
        {
            Description = 'Dirección Internet del responsable del interlocutor comerc.';
        }
        field(48; "Nota interior"; Text[40])
        {
            Description = 'Nota interna de la contabilidad financiera. Esta nota sirve solamente para informar sobre las peculiaridades del interlocutor comercial.';
        }
        field(49; "Organización"; Text[10])
        {
            Description = 'Organización de ventas (Nacional, Exportación, Ventas Especiales, etc)';
        }
        field(50; Canal; Text[30])
        {
            Description = 'Canal de Venta (Librerías, Distribución, Grandes Cuentas, Televenta, etc)';
        }
        field(51; Sector; Text[10])
        {
            Description = 'Constante 10';
        }
        field(52; "Oficina ventas"; Text[10])
        {
            Description = 'Delegación (p. ej. una sucursal) responsable de la comercialización de determinados productos y servicios en una determinada zona geográfica.';
        }
        field(53; "Gr.vendedores"; Text[10])
        {
            Description = 'Grupo de comerciales responsables de la gestión de ventas para determinados productos o prestaciones de servicios.';
        }
        field(54; "Grupo clientes"; Text[10])
        {
            Description = 'Define un determinado grupo de cliente (p. ej. mayoristas o minoristas) y se utiliza para determinar precios y con fines estadísticos.';
        }
        field(55; Moneda; Text[10])
        {
            Description = 'Moneda del cliente de un área de ventas. En la organización de ventas indicada se liquida al cliente en esta moneda.';
        }
        field(56; "Cta.en deudor2"; Text[12])
        {
            Description = 'Este campo contiene nuestro número de cuenta con el cliente o proveedor.';
        }
        field(57; "Prioridad de entrega"; Text[30])
        {
            Description = 'Prioridad de entrega asignada a una posición.01 URGENTE02 NORMAL';
        }
        field(58; "Condición expedición"; Text[30])
        {
            Description = 'Estrategia general de expedición con la que se entregan mercancías del proveedor al cliente.';
        }
        field(59; "Relevante ARE"; Text[30])
        {
            Description = 'Este indicador gestiona el proceso de la gestión ARE (acuse de recibo de entrega). La gestión ARE se activa al conectar el indicador "relevante para ARE" en la vista de expedición para el cliente y al asignarlo a un tipo de posición de entrega en el Customizing.';
        }
        field(60; "Agrupamiento de pedidos"; Text[30])
        {
            Description = 'Indica si está o no permitido agrupar los pedidos de un cliente el momento de crear las entregas.';
        }
        field(61; "Entrega completa obligatoria"; Text[30])
        {
            Description = 'Indica si un pedido de cliente o de compras debe ser suministrado completamente en una sola entrega o si puede ser suministrado en varias entregas parciales.';
        }
        field(62; "Tratam. Posterior facturas"; Text[30])
        {
            Description = 'Indica si se deben imprimir las facturas para el tratamiento manual posterior.';
        }
        field(63; Rappel; Text[30])
        {
            Description = 'Controla si se puede conceder un rappel a un cliente.';
        }
        field(64; "Determ.precios"; Text[30])
        {
            Description = 'Indicador relevante para determinación de precios. Si el registro maestro representa un nodo en una jerarquía de clientes, el indicador de determinación de precio controlará si el nodo es relevante para la determinación de precio.';
        }
        field(65; "Fechas facturación"; Text[30])
        {
            Description = 'Identifica el calendario que fija las fechas de facturación del cliente.';
        }
        field(66; "Fe.listas fact."; Text[30])
        {
            Description = 'Indica el calendario de fábrica del cliente utilizado para el tratamiento de las listas de facturas.';
        }
        field(67; Incoterms; Text[30])
        {
            Description = 'Fórmulas usuales de contrato que corresponden a las reglas establecidas por la Camara de Comercio Internacional (ICC).';
        }
        field(68; "Condición de pago"; Text[30])
        {
            Description = 'Clave mediante la que se definen las condiciones de pago en forma de tipos de descuento y plazos de pago.';
        }
        field(69; "Class. Fiscal para el deudor"; Text[30])
        {
            Description = 'Identifica la obligación fiscal del cliente de acuerdo con la estructura fiscal de su país. Exento, no exento, IGIC, etc.Qué hay que mandar?';
        }
        field(70; "Código Cliente Santillana"; Text[10])
        {
            Description = 'Código de cliente interno SAP';
        }
        field(71; "Tipo de cliente"; Text[10])
        {
            Description = 'Central Ònica, Sucursal, Exterior';
        }
        field(72; "Tipo de nif"; Text[10])
        {
            Description = 'CUIT,NIT,RUC,RUT';
        }
        field(73; "Línea de negocio"; Text[10])
        {
        }
        field(74; "Grupo autoriz."; Text[10])
        {
        }
        field(75; "Zona de ventas"; Text[10])
        {
        }
        field(76; "Grupo de precios"; Text[10])
        {
        }
        field(77; "Lista de precios"; Text[10])
        {
        }
    }

    keys
    {
        key(Key1; "Código Cliente Santillana")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

