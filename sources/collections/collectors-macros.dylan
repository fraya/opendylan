Module:       collections-internals
Synopsis:     Collector macros
Author:       Keith Playford
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      See License.txt in this distribution for details.
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

// Unfortunately, the implicitly generated name for a collecting () call
// has to be unhygienic so that it can be referred to by name in more
// than one macro.

define macro collecting
  { collecting () ?:body end }
    => { collecting (?=_collector)
           ?body;
           collected(?=_collector)
         end }
  { collecting (as ?type:expression = ?init:expression ?source-options:*)
      ?:body
    end }
    => { collecting (?=_collector :: ?type = ?init ?source-options)
           ?body;
           collected(?=_collector)
         end }
  { collecting (as ?type:expression ?source-options:*) ?:body end }
    => { collecting (?=_collector :: ?type ?source-options)
           ?body;
           collected(?=_collector)
         end }
  // This variant could have returned values(collected(var1), collected(var2), ...)
  // to match the way unnamed collections work, but unfortunately that would break
  // current callers if it were changed now. (The callers I checked in OD would be
  // trivial to convert.)
  { collecting (?vars) ?:body end }
    => { ?vars;
         ?body }
vars:
  { }
    => { }
  { ?var, ... }
    => { ?var; ... }
var:
  { ?base-name:name :: ?:expression ?options:* using ?protocol:expression}
    => { let (?base-name) = ?protocol(?expression, ?options) }

  { ?base-name:name :: ?:expression ?options:* }
    => { let (?base-name) = collector-protocol(?expression, ?options) }

  { ?base-name:name ?options:* using ?protocol:expression}
    => { let (?base-name) = ?protocol(<list>, ?options) }

  { ?base-name:name ?options:* }
    => { let (?base-name) = collector-protocol(<list>, ?options) }

base-name:
  { ?:name }
    => { ?name ## "-collector",
         ?name ## "-add-first",
         ?name ## "-add-last",
         ?name ## "-add-sequence-first",
         ?name ## "-add-sequence-last",
         ?name ## "-collection" }

options:
  { }
    => { }
  { ?:name ?:expression ... }
    => { ?#"name", ?expression, ... }
  { = ?:expression ... }
    => { from:, ?expression, ... }
end macro;

define macro collect-first-into
  { collect-first-into (?:name, ?:expression) }
    => { ?name ## "-add-first"(?name ## "-collector", ?expression) }
end macro;

define macro collect-last-into
  { collect-last-into (?:name, ?:expression) }
    => { ?name ## "-add-last"(?name ## "-collector", ?expression) }
end macro;

// Default is to add last
define macro collect-into
  { collect-into (?:name, ?:expression) }
    => { ?name ## "-add-last"(?name ## "-collector", ?expression) }
end macro;

define macro collected
  { collected () }
    => { collected(?=_collector) }
  { collected (?:name) }
    => { ?name ## "-collection"(?name ## "-collector") }
end macro;

define macro collect-first
  { collect-first (?:expression) }
    => { collect-first-into(?=_collector, ?expression) }
end macro;

define macro collect-last
  { collect-last (?:expression) }
    => { collect-last-into(?=_collector, ?expression) }
end macro;

// Default is to add last
define macro collect
  { collect (?:expression) }
    => { collect-last-into(?=_collector, ?expression) }
end macro;
