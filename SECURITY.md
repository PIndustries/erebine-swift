# Security

Do not include API keys, session cookies, CSRF tokens, or customer content in
public issues. Report sensitive vulnerabilities privately using the repository
security advisory form. Credentials are supplied at runtime; redirects are
returned to the caller and are never followed automatically. Use a separate
Client for each origin and authentication surface. The SDK makes no automatic
retries; callers decide whether a failed operation can safely be repeated.
