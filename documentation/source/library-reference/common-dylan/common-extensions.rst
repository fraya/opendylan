****************************
The common-extensions Module
****************************

.. current-library:: common-dylan
.. current-module:: common-extensions

.. module:: common-extensions

The *common-extensions* module contains a variety of basic extensions to the Dylan
language that are applicable to almost all programs. *common-extensions* is exported from
the *common-dylan* library.  As a convenience, the *common-dylan* module re-exports
everything from the *common-extensions* and *dylan* modules.

* Application startup and shutdown and access to application command line.
* Extensions to the collections model.
* Extensions to the condition system.
* Additional control flow macros.
* Additional types and ways to create new types.
* Debugging utilities.
* Type conversions.

Applications
============

.. function:: application-arguments

   Returns the arguments passed to the running application.

   :signature: application-arguments => *arguments*

   :value arguments: An instance of :drm:`<simple-object-vector>`.

   :description:

     Returns the arguments passed to the running application as a vector
     of instances of :drm:`<byte-string>`.

   :seealso:

     - :func:`application-filename`
     - :func:`application-name`
     - :func:`tokenize-command-line`

.. function:: application-filename

   Returns the full filename of the running application.

   :signature: application-filename => *false-or-filename*

   :value false-or-filename: An instance of ``false-or(<byte-string>)``.

   :description:

     Returns the full filename (that is, the absolute pathname) of the
     running application, or :drm:`#f` if the filename cannot be
     determined.

   :example:

     The following is an example of an absolute pathname naming an
     application::

       "C:\\Program Files\\foo\\bar.exe"

   :seealso:

     - :func:`application-arguments`
     - :func:`application-name`
     - :func:`tokenize-command-line`

.. function:: application-name

   Returns the name of the running application.

   :signature: application-name => *name*

   :value name: An instance of :drm:`<byte-string>`.

   :description:

     Returns the name of the running application. This is normally the
     command name as typed on the command line and may be a non-absolute
     pathname.

   :example:

     The following is an example of a non-absolute pathname used to refer to
     the application name::

       "foo\\bar.exe"

   :seealso:

     - :func:`application-arguments`
     - :func:`application-filename`
     - :func:`tokenize-command-line`

.. function:: exit-application

   Terminates execution of the running application.

   :signature: exit-application *status* => ()

   :parameter status: An instance of :drm:`<integer>`.

   :description:

     Terminates execution of the running application, returning the
     value of *status* to whatever launched the application, for example
     an MS-DOS window or Windows 95/NT shell.

     .. note:: This function is also available from the :doc:`operating-system
               <../system/operating-system>` module.

   :seealso:

     - :func:`register-application-exit-function`

.. function:: register-application-exit-function

   Register a function to be executed when the application is about to exit.

   :signature: register-application-exit-function *function* => ()

   :parameter function: An instance of :drm:`<function>`.

   :description:

     Register a function to be executed when the application is about to
     exit. The Dylan runtime will make sure that these functions are executed.

     The *function* should not expect any arguments, nor expect that any return
     values be used.

     .. note:: Currently, the registered functions will be invoked in the reverse
        order in which they were added. This is **not** currently a contractual
        guarantee and may be subject to change.

     .. note:: This function is also available from the :doc:`operating-system
               <../system/operating-system>` module.

   :example:

   :seealso:

     - :func:`exit-application`

.. function:: tokenize-command-line

   Parses a command line into a command name and arguments.

   :signature: tokenize-command-line *line* => *command* #rest *arguments*

   :parameter line: An instance of :drm:`<byte-string>`.
   :value command: An instance of :drm:`<byte-string>`.
   :value #rest arguments: Instances of :drm:`<byte-string>`.

   :description:

     Parses the command specified in *line* into a command name and
     arguments. The rules used to tokenize the string are given in
     Microsoft's C/C++ reference in the section `"Parsing C Command-Line
     Arguments" <https://learn.microsoft.com/en-us/cpp/c-language/parsing-c-command-line-arguments?view=msvc-170>`_.

   :seealso:

     - :func:`application-arguments`
     - :func:`application-name`

Collections
===========

.. class:: <stretchy-sequence>
   :open:
   :abstract:

   The class of stretchy sequences.

   :superclasses: :drm:`<sequence>`, :drm:`<stretchy-collection>`

   :description:

     The class of stretchy sequences.

.. class:: <string-table>
   :sealed:
   :instantiable:

   The class of tables that use strings for keys.

   :superclasses: :drm:`<table>`

   :description:

     The class of tables that use instances of :drm:`<string>` for their
     keys. It is an error to use a key that is not an instance of
     :drm:`<string>`.

     Keys are compared with the equivalence predicate ``\=``.

     The elements of the table are instances of :drm:`<object>`.

     It is an error to modify a key once it has been used to add an element
     to a ``<string-table>``. The effects of modification are not defined.

     .. note:: This class is also exported from the *table-extensions* module
        of the *table-extensions* library.

.. generic-function:: concatenate!
   :open:

   A destructive version of the Dylan language's :drm:`concatenate`;
   that is, one that might modify its first argument.

   :signature: concatenate! *sequence* #rest *more-sequences* => *result-sequence*

   :parameter sequence: An instance of :drm:`<sequence>`.
   :parameter #rest more-sequences: Instances of :drm:`<sequence>`.
   :value result-sequence: An instance of :drm:`<sequence>`.

   :description:

     A destructive version of the Dylan language's :drm:`concatenate`;
     that is, one that might modify its first argument.

     It returns the concatenation of one or more sequences, in a
     sequence that may or may not be freshly allocated. If
     *result-sequence* is freshly allocated, then, as for
     :drm:`concatenate`, it is of the type returned by
     :drm:`type-for-copy` of *sequence*.

   :example:

     .. code-block:: dylan

       > define variable *x* = "great-";
       "great-"
       > define variable *y* = "abs";
       "abs"
       > concatenate! (*x*, *y*);
       "great-abs"
       > *x*;
       "great-abs"
       >

.. macro:: define table
   :defining:

   Defines a constant binding in the current module and initializes it
   to a new table object.

   :macrocall:
     .. parsed-literal:: 
        define table `name` [ :: `type` ] = { [ `key` => `element` ]* }

   :parameter name: A Dylan name *bnf*.
   :parameter type: A Dylan operand *bnf*. Default value: :drm:`<table>`.
   :parameter key: A Dylan expression *bnf*.
   :parameter element: A Dylan expression *bnf*.

   :description:

     Defines a constant binding *name* in the current module, and
     initializes it to a new table object, filled in with the keys and
     elements specified.

     If the argument *type* is supplied, the new table created is an
     instance of that type. Therefore *type* must be :drm:`<table>` or a
     subclass thereof. If *type* is not supplied, the new table created
     is an instance of a concrete subclass of :drm:`<table>`.

   :example:

     .. code-block:: dylan

       define table $colors :: <object-table>
         = { #"red" => $red,
             #"green" => $green,
             #"blue" => $blue };

.. generic-function:: difference
   :open:

   Returns a sequence containing the elements of one sequence that are
   not members of a second.

   :signature: difference *sequence-1* *sequence-2* #key *test* => *result-sequence*

   :parameter sequence-1: An instance of :drm:`<sequence>`.
   :parameter sequence-2: An instance of :drm:`<sequence>`.
   :parameter test: An instance of :drm:`<function>`. Default value: :drm:`==`.
   :value result-sequence: An instance of :drm:`<sequence>`.

   :description:

     Returns a sequence containing the elements of *sequence-1* that are
     not members of *sequence-2*. You can supply a membership test
     function as *test*.

   :example:

     .. code-block:: dylan

       > difference(#(1,2,3), #(2,3,4));
       #(1)
       >

.. function:: fill-table!

   Fills a table with the keys and elements supplied.

   :signature: fill-table! *table* *keys-and-elements* => *table*

   :parameter table: An instance of :drm:`<table>`.
   :parameter keys-and-elements: An instance of :drm:`<sequence>`.
   :value table: An instance of :drm:`<table>`.

   :description:

     Modifies table so that it contains the keys and elements supplied
     in the sequence *keys-and-elements*.

     This function interprets *keys-and-elements* as key-element pairs,
     that is, it treats the first element as a table key, the second as
     the table element corresponding to that key, and so on. The keys
     and elements should be suitable for *table*.

     Because *keys-and-elements* is treated as a sequence of paired
     key-element values, it should contain an even number of elements;
     if it contains an odd number of elements, *fill-table!* ignores the
     last element (which would have been treated as a key).

.. generic-function:: find-element
   :open:

   Returns an element from a collection such that the element satisfies
   a predicate.

   :signature: find-element *collection* *function* #key *skip* *failure* => *element*

   :parameter collection: An instance of :drm:`<collection>`.
   :parameter predicate: An instance of :drm:`<function>`.
   :parameter #key skip: An instance of :drm:`<integer>`. Default value: 0.
   :parameter #key failure: An instance of :drm:`<object>`. Default value: :drm:`#f`.
   :value element: An instance of :drm:`<object>`.

   :description:

     Returns a collection element that satisfies *predicate*.

     This function is identical to Dylan's :drm:`find-key`, but it
     returns the element that satisfies *predicate* rather than the key
     that corresponds to the element.

.. generic-function:: position
   :open:

   Returns the key at which a particular value occurs in a sequence.

   :signature: position *sequence* *target* #key *test* *start* *end* *skip* *count* => *position*

   :parameter sequence: An instance of :drm:`<sequence>`.
   :parameter target: An instance of :drm:`<object>`.
   :parameter #key test: An instance of :drm:`<function>`. Default value: :drm:`==`.
   :parameter #key start: An instance of :drm:`<integer>`. Default value: 0.
   :parameter #key end: An instance of :drm:`<object>`. Default value: :drm:`#f`.
   :parameter #key skip: An instance of :drm:`<integer>`. Default value: 0.
   :parameter #key count: An instance of :drm:`<object>`. Default value: :drm:`#f`.
   :value position: An instance of ``false-or(<integer>)``.

   :description:

     Returns the position at which *target* occurs in *sequence*.

     If *test* is supplied, *position* uses it as an equivalence
     predicate for comparing *sequence* 's elements to *target*. It should
     take two objects and return a boolean. The default predicate used is
     :drm:`==`.

     The *skip* argument is interpreted as it is by Dylan's :drm:`find-key`
     function: *position* ignores the first *skip* elements that match
     *target*, and if *skip* or fewer elements satisfy *test*, it
     returns :drm:`#f`.

     The *start* and *end* arguments indicate, if supplied, which subrange
     of the *sequence* is used for the search.

.. generic-function:: remove-all-keys!
   :open:

   Removes all keys in a mutable collection, leaving it empty.

   :signature: remove-all-keys! *mutable-collection* => ()

   :parameter mutable-collection: An instance of :drm:`<mutable-collection>`.

   :description:

     Modifies *mutable-collection* by removing all its keys and leaving it
     empty. There is a predefined method on :drm:`<table>`.

.. generic-function:: split
   :open:

   Split a sequence (e.g., a string) into subsequences delineated by a
   given separator.

   :signature: split *sequence* *separator* #key *start* *end* *count* *remove-if-empty?* => *parts*

   :parameter sequence: An instance of :drm:`<sequence>`.
   :parameter separator: An instance of :drm:`<object>`.
   :parameter #key start: An instance of :drm:`<integer>`.  Default value: 0.
   :parameter #key end: An instance of :drm:`<integer>`.  Default value: ``sequence.size``.
   :parameter #key count: An instance of :drm:`<integer>`.  Default value: no limit.
   :parameter #key remove-if-empty?: An instance of :drm:`<boolean>`.  Default value: #f.
   :value parts: An instance of :drm:`<sequence>`.

   :description:

     Splits *sequence* into subsequences, splitting at each occurrence
     of *separator*.  The *sequence* is searched from left to right,
     starting at *start* and ending at ``end - 1``.

     The resulting *parts* sequence is limited in size to *count* elements.

     If *remove-if-empty?* is true, the result will not contain any
     subsequences that are empty.

   :seealso:
     - :meth:`split(<sequence>, <function>)`
     - :meth:`split(<sequence>, <sequence>)`
     - :meth:`split(<sequence>, <object>)`

.. method:: split
   :specializer: <sequence>, <function>

   Split a sequence (e.g., a string) into subsequences delineated by a
   given separator.

   :signature: split *sequence* *separator* #key *start* *end* *count* *remove-if-empty?* => *parts*

   :parameter sequence: An instance of :drm:`<sequence>`.
   :parameter separator: An instance of :drm:`<function>`.
   :parameter #key start: An instance of :drm:`<integer>`.  Default value: 0.
   :parameter #key end: An instance of :drm:`<integer>`.  Default value: ``sequence.size``.
   :parameter #key count: An instance of :drm:`<integer>`.  Default value: no limit.
   :parameter #key remove-if-empty?: An instance of :drm:`<boolean>`.  Default value: #f.
   :value parts: An instance of :drm:`<sequence>`.

   This is in some sense the most basic method, since others can be implemented
   in terms of it.  The *separator* function must accept three arguments:

   1. The sequence in which to search for a separator,
   2. the start index in that sequence at which to begin searching, and
   3. the index at which to stop searching (exclusive).

   The *separator* function must return :drm:`#f` to indicate that no separator was
   found, or two values:

   1. The start index of the separator in the sequence and
   2. the index of the first element after the end of the separator.

   It is an error for the returned start and end indices to be equal since this
   is equivalent to splitting on an empty separator, which is undefined.  It is
   undefined what happens if the return values are outside the ``[start, end)``
   range passed to the *separator* function.

   The initial start and end indices passed to the separator function are the
   same as the *start* and *end* arguments passed to this method.  The
   separator function should stay within the given bounds whenever possible.
   (In particular it may not always be possible when the separator is a regular
   expression.)

   See `the source code
   <https://github.com/dylan-lang/opendylan/blob/6ef338a6b3b09d7715b5b1a51634c9c1a85d29c4/sources/common-dylan/common-extensions.dylan#L312>`_
   for :meth:`split(<sequence>, <object>)` for an example of using this method.

.. method:: split
   :specializer: <sequence>, <object>

   Split a sequence (e.g., a string) into subsequences separated by a specific
   object.

   :signature: split *sequence* *separator* #key *start* *end* *count* *remove-if-empty?* => *parts*

   :parameter sequence: An instance of :drm:`<sequence>`.
   :parameter separator: An instance of :drm:`<object>`.
   :parameter #key start: An instance of :drm:`<integer>`.  Default value: 0.
   :parameter #key end: An instance of :drm:`<integer>`.  Default value: ``sequence.size``.
   :parameter #key count: An instance of :drm:`<integer>`.  Default value: no limit.
   :parameter #key remove-if-empty?: An instance of :drm:`<boolean>`.  Default value: #f.
   :parameter #key test: An instance of :drm:`<function>`. Default value: :drm:`==`.
   :value parts: An instance of :drm:`<sequence>`.

   Splits *sequence* around each occurrence of *separator*, which is compared
   to each element with the *test* function.

   This method handles the relatively common case where *sequence* is a string
   and *separator* is a :drm:`<character>`.

   :example:

     .. code-block:: dylan

       split("a.b.c", '.')     => #("a", "b", "c")
       split(#[1, 2, 3, 4], 2) => #(#[1], #[3, 4])

.. method:: split
   :specializer: <sequence>, <sequence>

   Split a sequence (e.g., a string) into subsequences separated by another
   sequence.

   :signature: split *sequence* *separator* #key *start* *end* *count* *remove-if-empty?* => *parts*

   :parameter sequence: An instance of :drm:`<sequence>`.
   :parameter separator: An instance of :drm:`<sequence>`.
   :parameter #key start: An instance of :drm:`<integer>`.  Default value: 0.
   :parameter #key end: An instance of :drm:`<integer>`.  Default value: ``sequence.size``.
   :parameter #key count: An instance of :drm:`<integer>`.  Default value: no limit.
   :parameter #key remove-if-empty?: An instance of :drm:`<boolean>`.  Default value: #f.
   :parameter #key test: An instance of :drm:`<function>`. Default value: :drm:`==`.
   :value parts: An instance of :drm:`<sequence>`.

    Splits *sequence* around occurrences of the *separator* subsequence.  This
    handles the relatively common case where *sequence* and *separator* are
    both instances of :drm:`<string>`.

    :example:

       .. code-block:: dylan

          split("aabbccdd", "bb")) => #("aa", "ccdd")

    .. note:: If you want to use :gf:`split` to find a :drm:`<sequence>` which
              is a single element of another sequence it may not do what you
              expect because this method is more specific than
              :meth:`split(<sequence>, <object>)`.  This is expected to be a
              rare case that can be handled by using :meth:`split(<sequence>,
              <function>)` if necessary.

.. generic-function:: join
   :open:

   Join several sequences (e.g. strings) together, including a separator
   between each pair of adjacent sequences.

   :signature: join *sequences* *separator* #key *key* *conjunction* => *joined*
   :parameter sequences: An instance of :drm:`<sequence>`.
   :parameter separator: An instance of :drm:`<sequence>`.
   :parameter #key key: Transformation to apply to each item. Default value:
                        :drm:`identity`.
   :parameter #key conjunction: Last separator. Default value: #f
   :value joined: An instance of :drm:`<sequence>`.

   :description:

     Join *sequences* together, including *separator* between each sequence.

     If the first argument is empty, an empty sequence of type
     ``type-for-copy(separator)`` is returned. If *sequences* is of size one,
     the first element is returned. Otherwise, the resulting *joined* sequence
     will be of the same type as *sequences*.

     Every element in *sequences* is transformed by *key*, which is a function
     that must accept one argument.

     If *conjunction* is not false, it is used instead of *separator* to join
     the last pair of elements in *sequences*.

   :example:

   .. code-block:: dylan

     join(range(from: 1, to: 3), ", ",
          key: integer-to-string, conjunction: " and ")
     => "1, 2 and 3"

   :seealso:

     - :meth:`join(<sequence>, <sequence>)`
     - :gf:`split`

.. method:: join
   :specializer: <sequence>, <sequence>

   Join several sequences together, including a separator between each pair of
   adjacent sequences.

   :signature: join *sequences* *separator* #key *key* *conjunction* => *joined*
   :parameter items: An instance of :drm:`<sequence>`.
   :parameter separator: An instance of :drm:`<sequence>`.
   :parameter #key key: Transformation to apply to each item. An instance of :drm:`<function>`.
   :parameter #key conjunction: Last separator. An instance of ``false-or(<sequence>)``.
   :value joined: An instance of :drm:`<sequence>`.

   :seealso:

     - :gf:`join`
     - :gf:`split`

Conditions
==========

.. class:: <simple-condition>
   :sealed:
   :instantiable:

   The class of conditions that accept a format string and format arguments
   with which to build a message describing the condition.

   :superclasses: :class:`<condition>`

   :description:

     As the superclass of :drm:`<simple-error>`, :drm:`<simple-warning>`, and
     :drm:`<simple-restart>`, the :class:`<simple-condition>` class provides
     the ``format-string:`` and ``format-arguments:`` init keywords described
     in the DRM.

   :operations:

     - :drm:`condition-format-string`
     - :drm:`condition-format-arguments`

   :seealso:

     - The :doc:`format module <../io/format>` in the :doc:`IO library
       <../io/index>`.

.. generic-function:: condition-to-string
   :open:

   Returns a :drm:`<string>` representation of a condition object.

   :signature: condition-to-string *condition* => *string*

   :parameter condition: An instance of :drm:`<condition>`.
   :value string: An instance of :drm:`<string>`.

   :description:

     Returns a string representation of a general instance of
     :drm:`<condition>`.

     Note that it is often not necessary to write a method on this generic
     function for your condition classes because you can use the method
     provided by :class:`<simple-condition>`, usually via one of its
     subclasses, :drm:`<simple-error>`, :drm:`<simple-warning>`, or
     :drm:`<simple-restart>`. Simply make your condition a subclass of one of
     these classes and provide the ``format-string:`` and ``format-arguments:``
     init keywords.

.. method:: default-handler
   :specializer: <warning>

   Prints the message of a warning instance to the Open Dylan debugger
   window's messages pane.

   :signature: default-handler *warning* => *false*

   :parameter warning: An instance of :drm:`<warning>`.
   :value false: :drm:`#f`.

   :description:

     Prints the message of a warning instance to the Open Dylan debugger
     window's messages pane. It uses :func:`debug-message`, to do so.

     This method is a required, predefined method in the Dylan language,
     described on page 361 of the DRM as printing the warning's message
     in an implementation-defined way. We document this method here
     because our implementation of it uses the function
     :func:`debug-message`, which is defined in the *common-dylan*
     library. Thus to use this :drm:`default-handler` method on
     :drm:`<warning>`, your library needs to use the *common-dylan* library
     or a library that uses it, rather than simply using the Dylan
     library.

   :example:

     In the following code, the signalled messages appear in the Open
     Dylan debugger window.

     .. code-block:: dylan

       define class <my-warning> (<warning>)
       end class;

       define method say-hello()
         format-out("hello there!\\n");
         signal("help!");
         signal(make(<my-warning>));
         format-out("goodbye\\n");
       end method say-hello;

       say-hello();

     The following messages appear in the debugger messages pane::

       Application Dylan message: Warning: help!
       Application Dylan message: Warning: {<my-warning>}

     Where ``{<my-warning>}`` means an instance of ``<my-warning>``.

   :seealso:

     - :func:`debug-message`.
     - :drm:`default-handler`, page 361 of the DRM.

.. function:: default-last-handler

   Formats and outputs a Dylan condition using :gf:`condition-to-string`
   and passes control on to the next handler.

   :signature: default-last-handler *serious-condition* *next-handler* => ()

   :parameter serious-condition: A object of class :drm:`<serious-condition>`.
   :parameter next-handler: A function.

   :description:

     A handler utility function defined on objects of class
     :drm:`<serious-condition>` that can be by bound dynamically around a
     computation via :drm:`let handler <handler>` or installed globally
     via :macro:`define last-handler`.

     This function formats and outputs the Dylan condition
     *serious-condition* using :gf:`condition-to-string` from this library,
     and passes control on to the next handler.

     This function is automatically installed as the last handler if
     your library uses the *common-dylan* library.

   :example:

     The following form defines a dynamic handler around some body:

     .. code-block:: dylan

       let handler <serious-condition> = default-last-handler;

     while the following form installs a globally visible last-handler:

     .. code-block:: dylan

       define last-handler <serious-condition>
         = default-last-handler;

   :seealso:

     - :macro:`define last-handler`
     - *win32-last-handler* in the *C FFI and Win32* library reference, under
       library *win32-user* and module *win32-default-handler*.

.. macro:: define last-handler
   :defining:

   Defines a "last-handler" to be used after any dynamic handlers and
   before calling :drm:`default-handler`.

   :macrocall:
     .. parsed-literal:: 
        define last-handler (`condition`, #key `test`, `init-args`) = `handler` ;

        define last-handler `condition` = `handler`;

        define last-handler;

   :parameter condition: A Dylan expression *bnf*. The class of
     condition for which the handler should be invoked.
   :parameter test: A Dylan expression *bnf*. A function of one argument
     called on the condition to test applicability of the handler.
   :parameter init-args: A Dylan expression *bnf*. A sequence of
     initialization arguments used to make an instance of the handler's
     condition class.
   :parameter handler: A Dylan expression *bnf*. A function of two
     arguments,
   :parameter condition: and *next-handler*, that is called on a
     condition which matches the handler's condition class and test
     function.

   :description:

     A last-handler is a global form of the dynamic handler introduced
     via :drm:`let handler <handler>`, and is defined using an identical
     syntax. The last handler is treated as a globally visible dynamic
     handler. During signalling if a last-handler has been installed
     then it is the last handler tested for applicability before
     :drm:`default-handler` is invoked. If a last-handler has been
     installed then it is also the last handler iterated over in a call
     to :drm:`do-handlers`.

     The first two defining forms are equivalent to the two alternate
     forms of let handler. If more than one of these first defining
     forms is executed then the last one executed determines the
     installed handler. The current last-handler can be uninstalled by
     using the degenerate third case of the defining form, that has no
     condition description or handler function.

     The intention is that libraries will install last handlers to
     provide basic runtime error handling, taking recovery actions such
     as quitting the application, trying to abort the current
     application operation, or entering a connected debugger.

   :example:

     The following form defines a last-handler function called
     *default-last-handler* that is invoked on conditions of class
     :drm:`<serious-condition>`:

     .. code-block:: dylan

       define last-handler <serious-condition>
         = default-last-handler;

   :seealso:

     - *win32-last-handler* in the *C FFI and Win32* library reference,
       under library *win32-user* and module *win32-default-handler*.

Control Flow
============

.. macro:: iterate
   :statement:

   Iterates over a body.

   :macrocall:
     .. parsed-literal:: 

        iterate `name` ({`argument` = `init-value`}*)
          [ `body` ]
        end [ iterate ]

   :parameter name: A Dylan variable-name *bnf*.
   :parameter argument: A Dylan variable-name *bnf*.
   :parameter init-value: A Dylan expression *bnf*.
   :parameter body: A Dylan body *bnf*.
   :value value: Zero or more instances of :drm:`<object>`.

   :description:

     Defines a function that can be used to iterate over a body. It is
     similar to *for*, but allows you to control when iteration will
     occur.

     It creates a function called *name* which will perform a single
     step of the iteration at a time; *body* can call *name* whenever it
     wants to iterate another step. The form evaluates by calling the
     new function with the initial values specified.

     Any values returned by `body` are returned from the ``iterate`` call.

   :example: Compute the factorial of 5

     .. code-block:: dylan

        let fact5 = iterate loop (x = 5, result = 1)
                      if (x == 1)
                        result
                      else
                        loop(x - 1, result * x)
                      end
                    end;

.. macro:: when
   :statement:

   Executes an implicit body if a test expression is true, and does
   nothing if the test is false.

   :macrocall:
     .. parsed-literal:: 
        when (`test`) [ `consequent` ] end [ when ]

   :parameter test: A Dylan expression *bnf*.
   :parameter consequent: A Dylan body *bnf*.
   :value value: Zero or more instances of :drm:`<object>`.

   :description:

     Executes *consequent* if *test* is true, and does nothing if *test*
     is false.

     This macro behaves identically to Dylan's standard :drm:`if`
     statement macro, except that there is no alternative flow of
     execution when the test is false.

   :example:

     .. code-block:: dylan

        when (*thread-count* = 0)
	  exit-application(0)
        end;

Convenience
===========

.. function:: ignore

   A compiler directive that tells the compiler it must not issue a
   warning if its argument is bound but not referenced.

   :signature: ignore *variable* => ()

   :parameter variable: A Dylan variable-name *bnf*.

   :description:

     When the compiler encounters a variable that is bound but not
     referenced, it normally issues a warning. The ``ignore`` function
     is a compiler directive that tells the compiler it *must not* issue
     this warning if *variable* is bound but not referenced. The
     ``ignore`` function has no run-time cost.

     The ``ignore`` function is useful for ignoring arguments passed to,
     or values returned by, a function, method, or macro. The function
     has the same extent as a :drm:`let`; that is, it applies to the
     smallest enclosing implicit body.

     Use ``ignore`` if you never intend to reference *variable* within
     the extent of the ``ignore``. The compiler will issue a warning to
     tell you if your program violates the ``ignore``. If you are not
     concerned about the ``ignore`` being violated, and do not wish to
     be warned if violation occurs, use :func:`ignorable` instead.

   :example:

     This function ignores some of its arguments:

     .. code-block:: dylan

       define method foo (x ::<integer>, #rest args)
         ignore(args);
         ...
       end

     Here, we use *ignore* to ignore one of the values returned by *fn*:

     .. code-block:: dylan

       let (x,y,z) = fn();
       ignore(y);

   :seealso:

     - :func:`ignorable`

.. function:: ignorable

   A compiler directive that tells the compiler it *need not* issue a
   warning if its argument is bound but not referenced.

   :signature: ignorable *variable* => ()

   :parameter variable: A Dylan variable-name *bnf*.

   :description:

     When the compiler encounters a variable that is bound but not
     referenced, it normally issues a warning. The ``ignorable``
     function is a compiler directive that tells the compiler it *need
     not* issue this warning if *variable* is bound but not referenced.
     The ``ignorable`` function has no run-time cost.

     The ``ignorable`` function is useful for ignoring arguments passed
     to, or values returned by, a function, method, or macro. The
     function has the same extent as a :drm:`let`; that is, it applies
     to the smallest enclosing implicit body.

     The ``ignorable`` function is similar to :func:`ignore`. However,
     unlike :func:`ignore`, it does not issue a warning if you
     subsequently reference *variable* within the extent of the
     ``ignorable`` declaration. You might prefer ``ignorable`` to
     :func:`ignore` if you are not concerned about such violations and
     do not wish to be warned about them.

   :example:

     This function ignores some of its arguments:

     .. code-block:: dylan

       define method foo (x ::<integer>, #rest args)
         ignorable(args);
         ...
       end

     Here, we use ``ignorable`` to ignore one of the values returned by
     *fn*:

     .. code-block:: dylan

       let (x,y,z) = fn();
       ignorable(y);

   :seealso:

     - :func:`ignore`

.. constant:: $unfound

   A unique value that can be used to indicate that a search operation
   failed.

   :type: <list>
   :value: A unique value.

   :description:

     A unique value that can be used to indicate that a search operation
     failed.

   :example:

     .. code-block:: dylan

        if (unfound?(element(section-index-table, section-name,
                             default: $unfound)))
          section-index-table[section-name] := section-index-table.size + 1;
          write-record(stream, #"SECTIONNAME", section-name);
        end if;

   :seealso:

     - :func:`found?`
     - :func:`unfound?`
     - :func:`unfound`

.. function:: unfound

   Returns the unique "unfound" value, :const:`$unfound`.

   :signature: unfound () => *unfound-marker*

   :value unfound-marker: The value :const:`$unfound`.

   :description:

   Returns the unique "unfound" value, :const:`$unfound`.

   :example:

      See :const:`$unfound`.

   :seealso:

     - :func:`found?`
     - :func:`unfound?`
     - :const:`$unfound`

.. function:: found?

   Returns true if *object* is not equal to :const:`$unfound`, and false otherwise.

   :signature: found? *object* => *boolean*

   :parameter object: An instance of :drm:`<object>`.
   :value boolean: An instance of :drm:`<boolean>`.

   :description:

     Returns true if *object* is not equal to :const:`$unfound`, and false otherwise.

     It uses ``\=`` as the equivalence predicate.

   :example:

      See :const:`$unfound`.

   :seealso:

     - :const:`$unfound`
     - :func:`unfound?`
     - :func:`unfound`

.. function:: unfound?

   Returns true if its argument is equal to the unique "unfound" value,
   :const:`$unfound`, and false if it is not.

   :signature: unfound? *object* => *unfound?*

   :parameter object: An instance of :drm:`<object>`.
   :value unfound?: An instance of :drm:`<boolean>`.

   :description:

     Returns true if *object* is equal to the unique "unfound" value,
     :const:`$unfound`, and false if it is not. It uses ``\=``
     as the equivalence predicate.

   :example:

      See :const:`$unfound`.

   :seealso:

     - :func:`found?`
     - :const:`$unfound`
     - :func:`unfound`

.. constant:: $unsupplied

   A unique value that can be used to indicate that a keyword was not
   supplied.

   :type: <list>
   :value: A unique value.

   :description:

     A unique value that can be used to indicate that a keyword was not
     supplied.

   :example:

     .. code-block:: dylan

        define method find-next-or-previous-string
            (frame :: <editor-state-mixin>,
             #key reverse? = $unsupplied)
         => ()
          let editor :: <basic-editor> = frame-editor(frame);
          let reverse?
            = if (supplied?(reverse?))
                reverse?
              else
                editor-reverse-search?(editor)
              end;
          ...
        end;

   :seealso:

     - :func:`supplied?`
     - :func:`unsupplied`
     - :func:`unsupplied?`

.. function:: unsupplied

   Returns the unique "unsupplied" value, :const:`$unsupplied`.

   :signature: unsupplied () => *unsupplied-marker*

   :value unsupplied-marker: The value :const:`$unsupplied`.

   :description:

     Returns the unique "unsupplied" value, :const:`$unsupplied`.

   :example:

      See :const:`$unsupplied`.

   :seealso:

     - :func:`supplied?`
     - :const:`$unsupplied`
     - :func:`unsupplied?`

.. function:: supplied?

   Returns true if its argument is not equal to the unique "unsupplied"
   value, :const:`$unsupplied`, and false if it is.

   :signature: supplied? *object* => *supplied?*

   :parameter object: An instance of :drm:`<object>`.
   :value supplied?: An instance of :drm:`<boolean>`.

   :description:

     Returns true if *object* is not equal to the unique "unsupplied"
     value, :const:`$unsupplied`, and false if it is. It uses ``\=`` as
     the equivalence predicate.

   :example:

      See :const:`$unsupplied`.

   :seealso:

     - :const:`$unsupplied`
     - :func:`unsupplied`
     - :func:`unsupplied?`

.. function:: unsupplied?

   Returns true if its argument is equal to the unique "unsupplied"
   value, :const:`$unsupplied`, and false if it is not.

   :signature: unsupplied? *value* => *boolean*

   :parameter value: An instance of :drm:`<object>`.
   :value boolean: An instance of :drm:`<boolean>`.

   :description:

     Returns true if its argument is equal to the unique "unsupplied"
     value, :const:`$unsupplied`, and false if it is not. It uses ``\=``
     as the equivalence predicate.

   :example:

      See :const:`$unsupplied`.

   :seealso:

     - :func:`supplied?`
     - :const:`$unsupplied`
     - :func:`unsupplied`

Conversions
===========

.. function:: float-to-string

   Formats a floating-point number to a string.

   :signature: float-to-string *float* => *string*

   :parameter float: An instance of ``<float>``.
   :value string: An instance of :drm:`<string>`.

   :description:

     Formats a floating-point number to a string. It uses scientific
     notation where necessary.

.. function:: integer-to-string

   Returns a string representation of an integer.

   :signature: integer-to-string *integer* #key *base* *size* *fill* => *string*

   :parameter integer: An instance of :drm:`<integer>`.
   :parameter base: An instance of :drm:`<integer>` (default 10).
   :parameter size: An instance of :drm:`<integer>` (default 0).
   :parameter fill: An instance of :drm:`<character>` (default 0).
   :parameter lowercase?: An instance of :drm:`<boolean>` (default :drm:`#f`).
   :value string: An instance of :drm:`<byte-string>`.

   :description:

     Returns a string representation of *integer* in the given *base*, which
     must be between 2 and 36. The size of the string is right-aligned to
     *size*, and it is filled with the *fill* character. If the string is
     already larger than *size* then it is not truncated. If *lowercase?* is
     true then lowercase characters are used when *base* is higher than 10.

.. function:: string-to-integer

   Returns the integer represented by its string argument, or by a
   substring of that argument, in a number base between 2 and 36.

   :signature: string-to-integer *string* #key *base* *start* *end* *default* => *integer* *next-key*

   :parameter string: An instance of :drm:`<byte-string>`.
   :parameter #key base: An instance of :drm:`<integer>`. Default value: 10.
   :parameter #key start: An instance of :drm:`<integer>`. Default value: 0.
   :parameter #key end: An instance of :drm:`<integer>`. Default value: ``sizeof(*string*)``.
   :parameter #key default: An instance of :drm:`<integer>`. Default value: :const:`$unsupplied`.
   :value integer: An instance of :drm:`<integer>`.
   :value next-key: An instance of :drm:`<integer>`.

   :description:

     Returns the integer represented by the characters of *string* in
     the number base *base*, where *base* is between 2 and 36. You can
     constrain the search to a substring of *string* by giving values
     for *start* and *end*.

     This function returns the next key beyond the last character it
     examines.

     If there is no integer contained in the specified region of the
     string, this function returns *default*, if specified. If you do
     not give a value for *default*, this function signals an error.

     This function is similar to C's ``strtod`` function.

Debugging
=========

.. macro:: assert
   :statement:

   Signals an error if the expression passed to it evaluates to false.

   :macrocall:
     .. parsed-literal:: 
        assert `expression` `format-string` [`format-arg`] => `false`

     .. parsed-literal:: 
        assert `expression` => `false`

   :parameter expression: A Dylan expression *bnf*.
   :parameter format-string: A Dylan expression *bnf*.
   :parameter format-arg: A Dylan expression *bnf*.

   :value false: :drm:`#f`.

   :description:

     Signals an error if *expression* evaluates to :drm:`#f`.

     An assertion or "assert" is a simple tool for testing that
     conditions hold in program code.

     The *format-string* is a format string as defined on page 112 of
     the DRM. If *format-string* is supplied, the error is formatted
     accordingly, along with any instances of *format-arg*.

     If *expression* is not :drm:`#f`, :macro:`assert` does not evaluate
     *format-string* or any instances of *format-arg*.

   :seealso:

     - :macro:`debug-assert`

.. macro:: debug-assert
   :statement:

   Signals an error if the expression passed to it evaluates to false —
   but only when the code is compiled in interactive development mode.

   :macrocall:
     .. parsed-literal:: 
        debug-assert `expression` `format-string` [`format-arg`] => `false`

     .. parsed-literal:: 
        debug-assert `expression` => `false`

   :parameter expression: A Dylan expression *bnf*.
   :parameter format-string: A Dylan expression *bnf*.
   :parameter format-arg: A Dylan expression *bnf*.
   :value false: :drm:`#f`.

   :description:

     Signals an error if *expression* evaluates to false — but only when
     the code is compiled in debugging mode.

     An assertion or "assert" is a simple and popular development tool
     for testing conditions in program code.

     This macro is identical to :macro:`assert`, except that the assert is
     defined to take place only while debugging.

     The Open Dylan compiler removes debug-assertions when it compiles
     code in "production" mode as opposed to "debugging" mode.

     The *format-string* is a format string as defined on page 112 of
     the DRM.

   :seealso:

     - :macro:`assert`

.. function:: debug-message

   Formats a string and outputs it to the debugger.

   :signature: debug-message *format-string* #rest *format-args* => ()

   :parameter format-string: An instance of :drm:`<string>`.
   :parameter #rest format-args: Instances of :drm:`<object>`.

   :description:

     Formats a string and outputs it to the debugger.

     The *format-string* is a format string as defined on page 112 of
     the DRM.

Types
=====

.. class:: <byte-character>
   :sealed:

   The class of 8-bit characters that instances of :drm:`<byte-string>` can
   contain.

   :superclasses: :drm:`<character>`

   :description:

     The class of 8-bit characters that instances of :drm:`<byte-string>`
     can contain.

.. function:: false-or

   Returns a union type comprised of ``singleton(#f)`` and one or more types.

   :signature: false-or *type* #rest *more-types* => *result-type*

   :parameter type: An instance of :drm:`<type>`.
   :parameter #rest more-types: Instances of :drm:`<type>`.
   :value result-type: An instance of :drm:`<type>`.

   :description:

     Returns a union type comprised of ``singleton(#f)``, *type*, any
     other types passed as *more-types*.

     This function is useful for specifying slot types and function
     return values.

     The expression

     .. code-block:: dylan

       false-or(*t-1*, *t-2*, ..)

     is type-equivalent to

     .. code-block:: dylan

       type-union(singleton(#f), *t-1*, *t-2*, ..)

.. function:: one-of

   Returns a union type comprised of singletons formed from its arguments.

   :signature: one-of *object* #rest *more-objects* => *type*

   :parameter object: An instance of :drm:`<object>`.
   :parameter #rest more-objects: Instances of :drm:`<object>`.
   :value type: An instance of :drm:`<type>`.

   :description:

     Returns a union type comprised of ``singleton(object)`` and the
     singletons of any other objects passed with *more-object*.

     .. code-block:: dylan

       one-of(x, y, z)

     Is a type expression that is equivalent to

     .. code-block:: dylan

       type-union(singleton(x), singleton(y), singleton(z))

.. function:: subclass

   Returns a type representing a class and its subclasses.

   :signature: subclass *class* => *subclass-type*

   :parameter class: An instance of :drm:`<class>`.
   :value subclass-type: An instance of :drm:`<type>`.

   :description:

     Returns a type that describes all the objects representing
     subclasses of the given class. We term such a type a *subclass
     type*.

     The ``subclass`` function is allowed to return an existing type if
     that type is type equivalent to the subclass type requested.

     Without ``subclass``, methods on generic functions (such as Dylan's
     standard :drm:`make` and :drm:`as`) that take types as arguments
     are impossible to reuse without resorting to ad hoc techniques. In
     the language defined by the DRM, the only mechanism available for
     specializing such methods is to use singleton types. A singleton
     type specializer used in this way, by definition, gives a method
     applicable to exactly one type. In particular, such methods are not
     applicable to subtypes of the type in question. In order to define
     reusable methods on generic functions like this, we need a type
     which allows us to express applicability to a type and all its
     subtypes.

     For an object *O* and class *Y*, the following :drm:`instance?`
     relationship applies:

     **INSTANCE-1**: ``instance?(*O*, subclass(*Y*))``
       True if and only if *O* is a class and *O* is a subclass of *Y*.

     For classes *X* and *Y* the following :drm:`subtype?` relationships hold
     (note that a rule applies only when no preceding rule matches):

     **SUBTYPE-1**: ``subtype?(subclass(*X*), subclass(*Y*))``
       True if and only if *X* is a subclass of *Y*.

     **SUBTYPE-2**: ``subtype?(singleton(*X*), subclass(*Y*))``
       True if and only if *X* is a class and *X* is a subclass of *Y*.

     **SUBTYPE-3**: ``subtype?(subclass(*X*), singleton(*Y*))``
       Always false.

     **SUBTYPE-4**: ``subtype?(subclass(*X*), *Y*)``
       where *Y* is not a subclass type. True if *Y* is :drm:`<class>` or
       any proper superclass of :drm:`<class>` (including :drm:`<object>`, any
       implementation-defined supertypes, and unions involving any of
       these). There may be other implementation-defined combinations of
       types *X* and *Y* for which this is also true.

     **SUBTYPE-5**: ``subtype?(*X*, subclass(*Y*))``
       where *X* is not a subclass type. True if *Y* is :drm:`<object>` or any
       proper supertype of :drm:`<object>` and *X* is a subclass of :drm:`<class>`.

     Note that by subclass relationships *SUBTYPE-4* and *SUBTYPE-5*, we get
     this correspondence: :drm:`<class>` and ``subclass(<object>)`` are type
     equivalent.

     Where the :drm:`subtype?` test has not been sufficient to determine an
     ordering for a method's argument position, the following further
     method-ordering rules apply to cases involving subclass types (note that
     a rule applies only when no preceding rule matches):

     - **SPECIFICITY+1**. ``subclass(*X*)`` precedes ``subclass(*Y*)``
       when the argument is a class *C* and *X* precedes *Y* in the
       class precedence list of *C*.

     - **SPECIFICITY+2**. ``subclass(*X*)`` always precedes *Y*, *Y* not
       a subclass type. That is, applicable subclass types precede any
       other applicable class-describing specializer.

     The constraints implied by sealing come by direct application of sealing
     rules 1–3 (see page 136 of the DRM) and the following disjointness
     criteria for subclass types (note that a rule applies only when no
     preceding rule matches):

     - **DISJOINTNESS+1**. A subclass type ``subclass(*X*)`` and a
       type *Y* are disjoint if *Y* is disjoint from :drm:`<class>`, or if
       *Y* is a subclass of :drm:`<class>` without instance classes that
       are also subclasses of *X*.

     - **DISJOINTNESS+2**. Two subclass types ``subclass(*X*)`` and
       ``subclass(*Y*)`` are disjoint if the classes *X* and *Y* are
       disjoint.

     - **DISJOINTNESS+3**. A subclass type ``subclass(*X*)`` and a
       singleton type ``singleton(*O*)`` are disjoint unless *O* is a
       class and *O* is a subclass of *X*.

     The guiding principle behind the semantics is that, as far as possible,
     methods on classes called with an instance should behave isomorphically
     to corresponding methods on corresponding subclass types called with the
     class of that instance. So, for example, given the heterarchy::

       <object>
         \|
         <A>
         / \\
       <B> <C>
        \\ /
         <D>

     and methods:

     .. code-block:: dylan

       method foo (<A>)
       method foo (<B>)
       method foo (<C>)
       method foo (<D>)

       method foo-using-type (subclass(<A>))
       method foo-using-type (subclass(<B>))
       method foo-using-type (subclass(<C>))
       method foo-using-type (subclass(<D>))

     that for a direct instance *D1* of ``<D>``:

     .. code-block:: dylan

       foo-using-type(<D>)

     should behave analogously to:

     .. code-block:: dylan

       foo(D1)

     with respect to method selection.

   :example:

     .. code-block:: dylan

       define class <A> (<object>) end;
       define class <B> (<A>) end;
       define class <C> (<A>) end;
       define class <D> (<B>, <C>) end;

       define method make (class :: subclass(<A>), #key)
         print("Making an <A>");
         next-method();
       end method;

       define method make (class :: subclass(<B>), #key)
         print("Making a <B>");
         next-method();
       end method;

       define method make (class :: subclass(<C>), #key)
         print("Making a <C>");
         next-method();
       end method;

       define method make (class :: subclass(<D>), #key)
         print("Making a <D>");
         next-method();
       end method;

     ::

       ? make(<D>);
       Making a <D>
       Making a <B>
       Making a <C>
       Making an <A>
       {instance of <D>}
