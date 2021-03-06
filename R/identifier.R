#' Identifier Consturction
#'
#' This is the constructor function for objects of the \code{identifier}
#' class.
#'
#' An identifier in the semantic web is something that uniquely identifies
#' a resource. Identifiers can be represented as URI's (e.g.
#' \code{<http://example.com/id>}), or as QNAME's (e.g. \code{example:id}).
#'
#' The Semantic Web model also allows for resources to be anonymous, via
#' so-called blank nodes. We use identifiers whose QNAME prefix is an
#' underscore (e.g. \code{_:alice}).
#'
#' RDF4R stores identifiers as lists with the following fields:
#'
#' \code{sample_id = list(
#'   id  = "57d68e07-8315-4b30-9a8e-57226fd815d7",
#'   uri = "<http://openbiodiv.net/57d68e07-8315-4b30-9a8e-57226fd815d7>",
#'   qname = "openbiodiv:id",
#'   prefix = c(openbiodiv = "http://openbiodiv.net")
#' )}
#'
#' @param id \code{character}. Local ID, for example a UUID. The part of
#'   identifier after the prefix.
#'
#' @param prefix named \code{character}. The name corresponds to the
#'   prefix and the proper part to the namespace. Only the first element
#'   of the vector will be honored. If you don't supply a prefix, the ID
#'   will be treated as a URI and the QNAME and URI will be the same.
#'
#' @param blank optional \code{logical}. If you want to create a blank node.
#'
#' @return \code{identifier} object (a type of list).
#'
#' @examples
#'
#' a = identifier(
#'   id = "57d68e07-8315-4b30-9a8e-57226fd815d7",
#'   prefix = c(openbiodiv = "http://openbiodiv.net")
#' )
#'
#' b = identifier(
#'   id = "alice",
#'   blank = TRUE
#' )
#'
#' a
#' b
#'
#' @export
identifier = function(id, prefix = NA, blank = FALSE)
{
  if (blank == TRUE) {
    prefix = c("_" = "_")
  }

  if (length(id) != 1 || length(prefix) != 1|| length(names(prefix)) != 1) {
    warning("Arguments to `identifier` not of length 1 or missing names!
            Using first positions.")
  }

  id = strip_angle(id[1])
  prefix = strip_angle(prefix[1])
  uri = strip_angle(
    pasteif(prefix[1], id, cond = !is.na(prefix), return_value = id),
    reverse = TRUE
  )
  qname =
    pasteif(names(prefix)[1], id, sep = ":", cond = !is.na(prefix), return_value = uri)

  ll = list(id = id, uri = uri, qname = qname, prefix = prefix)
  class(ll) = "identifier"

  ll
}


#' Outputs an identifier in a default way
#'
#' @param id \code{identifier}
#'
#' @return \code{character} default representation.
#' @export
print.identifier = function(id)
{
  print(id$qname)
}




#' @describeIn identifier construct identifier via a lookup function.
#'
#' @param label \code{character(1)} Parameter that will be passed to the lookup
#'   functions. See \code{...} for details.
#' @param ... (lookup) functions that will be executed in order to
#'   obtain the identifier. The functions should have one argument to which
#'   \code{label} will be assigned during the call. As soon as we have a
#'   unique match the function execution halts. If there is no match, a
#'   URI with the base prefix (the one indiciated by "_base") and a UUID
#'   will be generated.
#'  @param FUN list of lookup functions to be tried. this can be omitted and
#'   instead the functions specified as additional arguments.
#' @param prefixes Named \code{character}. Contains the prefixes.
#' @param def_prefix The prefix to be used if lookup fails.
#'
#'
#' @examples
#'
#' @export
fidentifier = function(label, ...,  FUN = list(...), prefixes, def_prefix )
{
  # sanity
  stopifnot(is.character(label) && length(label) == 1 && is.character(prefixes))
  fi = 1
  partial_uri = character()
  while (fi <= length(FUN)) {
    partial_uri = FUN[[fi]](label)[[1]]
    if (length(partial_uri) == 1) {
      # found a unique solution
      # try to find if we have a prefix match
      pi = sapply(prefixes, function(p) {
        grepl(paste0("^", p), partial_uri) # does the partial_uri begin with p
      })
      prefix = prefixes[pi] # we could have multiple matches or no match, but this is fine as the identifier constructor acocmodates both
      # if we did have at least one match we need to properly form the id
      id = gsub(paste0("^", prefix[1]), "" , partial_uri)
      # now call normal constructor
      return(identifier(id, prefix = prefix))
    }
    fi = fi + 1
  }
  # if we are here, no unique solution has been found
  return(identifier(uuid::UUIDgenerate(), prefix = def_prefix))
}









#' Manufacturing Identifier Constructors
#'
#' @inheritParams fidentifier
#'
#' @return an identifier constructor function with one parameter
#'   (\code{label})
#'
#' @export
#' @examples
#'
#' openbiodiv_id = identifier_factory(simple_lookup,
#'   prefixes = prefixes,
#'   def_prefix = c(openbiodiv = "http://openbiodiv.net/"))
#'
#' openbiodiv_id("Teodor Georgiev")
#' openbiodiv_id("Pavel Stoev")
identifier_factory = function(...,  FUN = list(...), prefixes, def_prefix )
{
  function(llabel) {
    stopifnot(is.literal(llabel))
    fidentifier(label = llabel$squote, FUN = FUN, prefixes = prefixes, def_prefix = def_prefix, ...)
  }
}








#' Is the object an identifier?
#'
#' @param x object to check
#'
#' @return logical
#'
#' @export
is.identifier = function(x)
{
  if ("identifier" %in% class(x)) TRUE
  else FALSE
}
